statgit2 [![Build Status](https://travis-ci.org/soundasleep/statgit2.svg?branch=master)](https://travis-ci.org/soundasleep/statgit2)
========

Generate Git development statistics, a reboot of [statgit](https://github.com/soundasleep/statgit).

# Running

```
npm install
bundle install
bundle exec ruby generate.rb --url https://github.com/your/repository --database db/databse.sqlite3
```

This will generate reports in `output/` and a database stored locally as `db/database.sqlite3`.

A full list of options is available with `--help`.

# Tests

```
bundle exec rspec
```

# TODO

* `--from` and `--to` options
* Generate all of the base stats from [statgit](https://github.com/soundasleep/statgit)
* Write up features list
