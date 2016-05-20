#!/bin/ruby

repository_url = ENV['REPOSITORY'] || "https://github.com/soundasleep/statgit"

ENV['DATABASE'] = ARGV[0] || ":memory:"

require_relative "lib/preload"

# Do all the things
repository = CreateRepository.new(url: repository_url).call

AnalyseRepository.new(repository: repository).call
GenerateStatistics.new(repository: repository).call
GenerateReports.new(repository: repository).call
