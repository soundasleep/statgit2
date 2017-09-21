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

    LOG.info "Analysing commit #{commit.commit_hash} (#{percent_done})..."

    switched = false
    analysed = false

    # Rather than defining tool dependencies, just run all tools many times
    # (e.g. CountTodos depends on CountFiles to create commit.files)
    3.times do
      COMMIT_ANALYSERS.each do |tool|
        instance = tool.new(commit: commit, options: options)
        if instance.needs_update?
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

          LOG.info ">> #{tool}"
          result = instance.call
          analysed ||= !!result
        end
      end
    end

    return analysed
  end

  def needs_update?
    return COMMIT_ANALYSERS.any? do |tool|
      tool.new(commit: commit, options: options).needs_update?
    end
  end

  private

  def percent_done
    sprintf "%0.1f%%", (1 - (repository.commits.find_index(commit) / repository.commits.count.to_f)) * 100
  end

  def matching_regexp
    @matching_regexp ||= Regexp.new(repository.only_paths_matching)
  end
end
