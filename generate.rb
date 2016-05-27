#!/bin/ruby

require_relative "lib/preload"
repository_url = options[:url]

# Do all the things
repository = CreateRepository.new(url: repository_url, options: options).call

AnalyseRepository.new(repository: repository, options: options).call
GenerateStatistics.new(repository: repository, options: options).call
GenerateReports.new(repository: repository, options: options).call
