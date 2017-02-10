statgit2 [![Build Status](https://travis-ci.org/soundasleep/statgit2.svg?branch=master)](https://travis-ci.org/soundasleep/statgit2)
========

Generate Git development statistics, a reboot of [statgit](https://github.com/soundasleep/statgit).

# Running

```
npm install
ruby generate.rb --url https://github.com/your/repository --database db/databse.sqlite3
```

This will generate, by default, things in `output/` and a database stored locally as `db/database.sqlite3`.

# Tests

```
bundle exec rspec
```

# TODO

* `--from` and `--to` options
* Tests with rspec
* Generate all of the base stats from statgit
* Travis-CI build
* Write up features list
