require "json"
require "reek/cli/application"

class ReekSmells < AbstractCommitAnalyser
  include CommandLineHelper

  def needs_update?
    commit.reek_smells.empty?
  end

  def call
    argv = ["--format", "json", "--no-wiki-links", root_path]

    output = capture_output do
      Reek::CLI::Application.new(argv).execute
    end

    json = JSON.parse(output)
    json.each do |smell|
      # remove the root_path
      filename = smell["source"].split(root_path, 2).last

      file = commit.select_file(filename)
      raise "Could not identify file '#{smell["source"]}' in commit #{commit}" if file.nil?

      smell = file.reek_smells.create!(
        context: smell["context"],
        message: smell["message"],
        smell_type: smell["smell_type"],
        name: smell["name"] || "",
        count: smell["count"] || 0,
      )

      (smell["lines"] || []).each do |line|
        smell.reek_smell_lines.create! line_number: line
      end
    end

    commit.reload

    LOG.info "Found #{commit.reek_smells.size} code smells"
  end
end

COMMIT_ANALYSERS << ReekSmells
