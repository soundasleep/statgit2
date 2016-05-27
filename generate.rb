#!/bin/ruby

require_relative "lib/preload"

# Do all the things
repository = CreateRepository.new(options: options).call

AnalyseRepository.new(repository: repository, options: options).call
GenerateStatistics.new(repository: repository, options: options).call
GenerateReports.new(repository: repository, options: options).call
