#!/bin/ruby

repository_url = "https://github.com/soundasleep/rmagic"
ENV['database'] = "db/database.sqlite3"

require_relative "lib/preload"

# Do all the things
repository = CreateRepository.new(url: repository_url).call

AnalyseRepository.new(repository: repository).call
GenerateStatistics.new(repository: repository).call
GenerateReports.new(repository: repository).call
