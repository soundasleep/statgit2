class AnalyseCommit
  include CommandLineHelper

  attr_reader :commit, :options

  delegate :repository, to: :commit

  def initialize(commit:, options:)
    @commit = commit
    @options = options
  end

  def call
    LOG.info "Analysing commit #{commit.commit_hash}..."

    COMMIT_ANALYSERS.each do |tool|
      instance = tool.new(commit: commit)
      switched = false
      if instance.needs_update?
        unless switched
          execute_command "cd #{root_path} && git reset --hard && git checkout #{commit.commit_hash} && git reset --hard #{commit.commit_hash}"
          switched = true
        end

        LOG.debug ">> #{tool}"
        instance.call
      end
    end
  end
end
