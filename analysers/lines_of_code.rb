require "csv"

class LinesOfCode < AbstractCommitAnalyser
  include CommandLineHelper

  def needs_update?
    commit.lines_of_code_stats.empty?
  end

  def call
    command = "node_modules/.bin/cloc --csv --quiet #{root_path}"
    execute_command(command) do |csv|
      CSV.parse(csv) do |row|
        if row.length == 5
          stat = {
            files: row[0],
            language: row[1],
            blank: row[2],
            comment: row[3],
            code: row[4]
          }

          commit.lines_of_code_stats.create! stat
        end
      end
    end

    LOG.info "Found #{commit.lines_of_code_stats.size} languages with #{commit.lines_of_code_stats.map(&:code).reduce(&:+)} LOC"
  end
end

COMMIT_ANALYSERS << LinesOfCode
