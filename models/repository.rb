class Repository < ActiveRecord::Base
  include AnalysedCommits

  belongs_to :parent_repository, class_name: "Repository"

  has_many :commits, dependent: :destroy
  has_many :authors, dependent: :destroy
  has_many :file_paths, dependent: :destroy
  has_many :child_repositories, foreign_key: :parent_repository_id, class_name: "Repository", dependent: :destroy

  validates :url, presence: true

  def latest_commit
    @latest_commit ||= commits.last  # commit default order is author_date asc
  end

  def tests_repository
    @tests_repository ||= child_repositories.where(is_tests_only: true).first
  end

  def lines_of_code_per_day
    @lines_of_code_per_day ||= LinesOfCodePerDay.new(self).call
  end

  def ratio_of_tests_to_code_per_day
    @ratio_of_tests_to_code_per_day ||= RatioOfTestsToCodePerDay.new(self).call
  end

  def commit_activity
    @commit_activity ||= CommitActivity.new(self).call
  end

  def commits_per_day
    @commits_per_day ||= CommitsPerDay.new(self).call
  end

  def commits_per_hour
    @commits_per_hour ||= CommitsPerHour.new(self).call
  end

  def commits_per_author
    @commits_per_author ||= CommitsPerAuthor.new(self).call
  end

  def latest_commit_languages
    @latest_commit_languages ||= LatestCommitLanguages.new(self).call
  end

  def code_files_count_per_day
    @code_files_count ||= CodeFilesCountPerDay.new(self).call
  end

  def tests_files_count_per_day
    @tests_files_count ||= TestsFilesCountPerDay.new(self).call
  end

  def code_lines_of_code_per_day
    @code_lines_of_code ||= CodeLinesOfCodePerDay.new(self).call
  end

  def tests_lines_of_code_per_day
    @tests_lines_of_code ||= TestsLinesOfCodePerDay.new(self).call
  end

  def lines_of_code_per_file_per_day
    @lines_of_code_per_file_per_day ||= LinesOfCodePerFilePerDay.new(self).call
  end

  def code_lines_of_code_per_file_per_day
    @code_lines_of_code_per_file_per_day ||= CodeLinesOfCodePerFilePerDay.new(self).call
  end

  def tests_lines_of_code_per_file_per_day
    @tests_lines_of_code_per_file_per_day ||= TestsLinesOfCodePerFilePerDay.new(self).call
  end

  def lines_of_code_touched_per_month
    @lines_of_code_touched_per_month ||= LinesOfCodeTouchedPerMonth.new(self).call
  end

  def lines_of_code_touched_this_month
    @lines_of_code_touched_this_month ||= lines_of_code_touched_per_month.values.last
  end

  def files_with_most_revisions
    @files_with_most_revisions ||= FilesWithMostRevisions.new(self).call
  end

  def largest_files
    @largest_files ||= LargestFiles.new(self).call
  end

  def todos_per_day
    @todos_per_day ||= TodosPerDay.new(self).call
  end

  def fixmes_per_day
    @fixmes_per_day ||= FixmesPerDay.new(self).call
  end

  def files_with_most_todos
    @files_with_most_todos ||= FilesWithMostTodos.new(self).call
  end

  def files_with_most_fixmes
    @files_with_most_fixmes ||= FilesWithMostFixmes.new(self).call
  end

  def top_authors
    @top_authors ||= TopAuthors.new(self).call
  end

  def authors_with_commits
    @authors_with_commits ||= AuthorsWithCommits.new(self).call
  end

  def sass_stylesheets_per_day
    @sass_stylesheets_per_day ||= SassStylesheetsPerDay.new(self).call
  end

  def sass_rules_per_day
    @sass_rules_per_day ||= SassRulesPerDay.new(self).call
  end

  def sass_properties_per_rule_per_day
    @sass_properties_per_rule_per_day ||= SassPropertiesPerRulePerDay.new(self).call
  end

  def files_with_most_sass_rules
    @files_with_most_sass_rules ||= FilesWithMostSassRules.new(self).call
  end

  def files_with_most_contributors
    @files_with_most_contributors ||= FilesWithMostContributors.new(self).call
  end

  def total_ownership_per_author
    @total_ownership_per_author ||= TotalOwnershipPerAuthor.new(self).call
  end

  def file_path_instance_for(path_string)
    @file_path_instances ||= Hash[all_file_paths]
    @file_path_instances[path_string] ||= file_paths.create!(path: path_string)
  end

  def all_file_paths
    file_paths.map do |file_path|
      [file_path.path, file_path]
    end
  end

  def changes_by_author(author)
    @changes_by_author ||= ChangesByAuthor.new(self).call
    @changes_by_author[author.id] || 0
  end

  def revisions_for(file_path)
    @revisions_for_paths ||= RevisionsForPaths.new(self).call
    @revisions_for_paths[file_path] || 0
  end

  # TODO maybe these two _for methods can be merged into a single method
  def contributors_for(file_path)
    @contributors_for ||= ContributorsForPaths.new(self).call
    @contributors_for[file_path] || 0
  end

  def todos_count_for(commit)
    @todos_count_for ||= Hash[ FileTodo.joins(:commit)
        .where("commits.repository_id = ?", id)
        .select("commits.id AS commit_id, SUM(todo_count) AS todos_sum")
        .group("commit_id")
        .map { |row| [ row.commit_id, row.todos_sum ] } ]
    @todos_count_for[commit.id]
  end

  def fixmes_count_for(commit)
    @fixmes_count_for ||= Hash[ FileFixme.joins(:commit)
        .where("commits.repository_id = ?", id)
        .select("commits.id AS commit_id, SUM(fixme_count) AS fixmes_sum")
        .group("commit_id")
        .map { |row| [ row.commit_id, row.fixmes_sum ] } ]
    @fixmes_count_for[commit.id]
  end
end
