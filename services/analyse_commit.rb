class AnalyseCommit
  include CommandLineHelper

  attr_reader :commit

  delegate :repository, to: :commit

  def initialize(commit:)
    @commit = commit
  end

  def call
    LOG.info "Analysing commit #{commit.commit_hash}..."

    COMMIT_ANALYSERS.each do |tool|
      instance = tool.new(commit: commit)
      if instance.needs_update?
        LOG.debug ">> #{tool}"
        instance.call
      end
    end
  end
end
