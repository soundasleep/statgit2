require "fileutils"

class AnalyseCommit
  include CommandLineHelper

  attr_reader :commit, :options

  delegate :repository, to: :commit

  def initialize(commit:, options:)
    @commit = commit
    @options = options
  end

  def call
    return false unless needs_update?

    LOG.info "Analysing commit #{commit.commit_hash}#{repository.is_tests_only? ? " tests" : ""} (#{percent_done})..."

    switched = false
    analysed = false

    # Rather than defining tool dependencies, just run all tools many times
    # (e.g. CountTodos depends on CountFiles to create commit.files)
    3.times do
      commit_analysers.each do |analyser|
        if analyser.can_update? && analyser.needs_update? && !analyser.has_already_updated?
          unless switched
            execute_command "cd #{root_path} && git reset --hard && git checkout #{commit.commit_hash} && git reset --hard #{commit.commit_hash}"

            if repository.only_paths_matching.present?
              all_files_in(root_path).reject do |path|
                path.match(matching_regexp)
              end.each do |path|
                FileUtils.rm_rf(path, secure: true)
              end
            end

            switched = true
          end

          LOG.info ">> #{analyser.class.name}"
          result = analyser.call

          analyser.has_updated!

          analysed ||= !!result
        end
      end
    end

    return analysed
  end

  def needs_update?
    commit_analysers.any? do |analyser|
      analyser.can_update? && analyser.needs_update? && !analyser.has_already_updated?
    end
  end

  private

  def commit_analysers
    COMMIT_ANALYSERS.map do |tool|
      tool.new(commit: commit, options: options)
    end
  end

  def percent_done
    sprintf "%0.1f%%", (1 - (repository.commits.find_index(commit) / repository.commits.count.to_f)) * 100
  end

  def matching_regexp
    @matching_regexp ||= Regexp.new(repository.only_paths_matching)
  end
end
