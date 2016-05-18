#!/bin/ruby

repository = "https://github.com/soundasleep/rmagic"
ENV['database'] = "db/database.sqlite3"

require_relative "lib/preload"

Repository.create! url: repository

Repository.all.each do |r|
  puts "#{r}: #{r.url} -> #{r.created_at}"
end
