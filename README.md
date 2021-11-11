statgit2
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

## Requirements

- Ruby 2.6+ or 3.0+

# Tests

```
bundle exec rspec
```

# Notes

To handle large code bases, statgit2 permits you to split analysis over a long
period of time: use the `--max` or `--limit` switches to gradually build up your
development statistics with automated jobs.

## Examples

* [Openclerk](http://openclerk.org/stats/)

