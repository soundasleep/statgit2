statgit2
========

Generate Git development statistics, a reboot of [statgit](https://github.com/soundasleep/statgit).

# Running

```
npm install
ruby generate.rb https://github.com/your/repository
```

This will generate, by default, things in `output/` and a database stored locally as `db/database.sqlite3`.

# TODO

* Tests with rspec
* Generate all of the base stats from statgit
* Travis-CI build
