require "csv"

class LinesOfCode < AbstractCommitAnalyser
  include CommandLineHelper

  def can_update?
    true
  end

  def needs_update?
    commit.lines_of_code_stats.empty?
  end

  def call
    to_import = []

    slash = File::ALT_SEPARATOR || File::SEPARATOR
    command = "node_modules#{slash}.bin#{slash}cloc --csv --quiet #{root_path}"
    execute_command(command) do |csv|
      LOG.debug "cloc output: #{csv}" if LOG.debug?

      CSV.parse(csv) do |row|
        if row.length == 5
          to_import << LinesOfCodeStat.new(
            commit: commit,
            files: row[0],
            language: row[1],
            blank: row[2],
            comment: row[3],
            code: row[4]
          )
        end
      end
    end

    LinesOfCodeStat.import!(to_import)

    LOG.info "Found #{to_import.size} languages with #{to_import.map(&:code).reduce(&:+)} LOC"

    return to_import.any?
  end
end
