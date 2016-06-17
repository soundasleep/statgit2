class AnalyseFiles < AbstractCommitAnalyser
  def analysers
    @analysers ||= FILE_ANALYSERS.map do |analyser|
      analyser.new(commit: commit)
    end
  end

  def needs_update?
    commit.files.any? && analysers.any? do |analyser|
      analyser.needs_update?
    end
  end

  def call
    read_files = {}

    analysers.each do |analyser|
      to_import = []

      if analyser.needs_update?
        Dir["#{repository.root_path}**/*#{analyser.extension}"].each do |file|
          file_path = file_path_for(file)
          if file_path && File.file?(file)
            commit_file = commit.select_file(file_path)

            if commit_file
              read_files[file_path] ||= read_file(file)

              to_import << analyser.analyse(commit_file, read_files[file_path])
            end
          end
        end
      end

      to_import = to_import.compact

      if to_import.any?
        analyser.import(to_import)
      end

      LOG.info "Found #{to_import.size} #{analyser.class.name}"
    end
  end

  private

  def read_file(file)
    File.read(file)
  end
end

COMMIT_ANALYSERS << AnalyseFiles
