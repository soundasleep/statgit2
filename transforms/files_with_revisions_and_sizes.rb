class FilesWithRevisionsAndSizes
  include ReportHelper

  attr_reader :commit

  def initialize(commit)
    @commit = commit
  end

  def call
    result = commit.files.map do |file|
      [ file.full_path,
        {
          filename: file.full_path,
          revisions: file.revisions,
          size: file.size,
        } ]
    end

    Hash[result]
  end
end
