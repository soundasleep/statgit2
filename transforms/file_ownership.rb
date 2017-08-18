class FileOwnership
  include ReportHelper

  attr_reader :file

  def initialize(file)
    @file = file
  end

  def call
    return {} if file.total_lines.zero?

    result = file.git_blames.select do |blame|
      blame.author.present?
    end.map do |blame|
      [ blame.author.email,
        {
          filename: file.full_path,
          revisions: file.revisions,
          size: file.size,
          contributors: file.contributors,
          ownership: (blame.line_count * 1.0) / file.total_lines,
        } ]
    end

    result << ["anonymous", {filename: "blah", revisions: -1, size: -1, contributors: -1, ownership: 0.01}]

    Hash[result]
  end
end
