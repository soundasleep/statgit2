class AnalyseFiles < AbstractCommitAnalyser
  def analysers
    @analysers ||= FILE_ANALYSERS.map do |analyser|
      analyser.new(commit: commit, options: options)
    end
  end

  def needs_update?
    commit.files.any? && analysers.any? do |analyser|
      analyser.needs_update?
    end
  end

  def call
    read_files = {}
    successful_analysis = false

    analysers.each do |analyser|
      to_import = []

      if analyser.can_update? && analyser.needs_update? && !analyser.has_already_updated?
        LOG.info ">> #{analyser.class.name}"

        Dir["#{root_path}**/*#{analyser.extension}"].each do |file|
          file_path = file_path_for(file)
          if file_path && File.file?(file)
            commit_file = commit.select_file(file_path)

            if commit_file
              read_files[file_path] ||= read_file(file)

              to_import << analyser.analyse(commit_file, read_files[file_path])
            end
          end
        end

        to_import = to_import.compact
        analyser.has_updated!

        if to_import.any?
          analyser.import!(to_import)
          successful_analysis ||= true
        end

        LOG.info "Found #{to_import.size} #{analyser.class.name}"
      end
    end

    return successful_analysis
  end

  private

  def read_file(file)
    string = File.read(file)

    # get rid of any invalid characters
    string.encode("UTF-8", "UTF-8", invalid: :replace)
  end
end

COMMIT_ANALYSERS << AnalyseFiles
