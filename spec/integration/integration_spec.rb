require "spec_helper"
require "tmpdir"

describe "Integration tests", type: :integration do
  include IntegrationSpecSupport

  let(:url) { "https://github.com/soundasleep/statgit2" }
  let(:workspace) { Dir.mktmpdir }
  let(:database_dir) { Dir.mktmpdir }
  let(:database) { "#{database_dir}/database" }
  let(:integration_options) {
    default_options.merge({
      url: url,
      limit: 1,
      level: "error",
      workspace: workspace + "/",
      database: database,
    })
  }
  let(:options) { integration_options }

  describe "connect_to_database" do
    it "can be called multiple times" do
      connect_to_database(options)
      connect_to_database(options)

      expect(File.exist?(database)).to eq(true), "Database #{database} didn't exist"
    end
  end

  describe "analysing commits" do
    before do
      reset_workspace!
      analyse_repository!
    end

    describe "cloc" do
      it "has initialized the database with a single commit" do
        expect(repository.commits).to_not be_empty
        expect(repository.commits.size).to eq(1)
        expect(repository.analysed_commits.size).to eq(1)
        expect(repository.commits).to eq(repository.analysed_commits)
      end

      it "has files for that commit" do
        expect(repository.commits.first.files).to_not be_empty
      end

      context "when the cloc analyser has already run" do
        it "does not call the analyser again" do
          expect(repository.commits.first.completed_analysers).to_not be_empty
          expect_any_instance_of(LinesOfCode).to_not receive(:analyse)
          analyse_repository!
          expect(repository.commits.first.completed_analysers).to_not be_empty
        end

        context "when the original TODO analyser found zero results" do
          before do
            repository.commits.first.lines_of_code_stats.delete_all
          end

          it "does not call the analyser again" do
            expect(repository.commits.first.completed_analysers).to_not be_empty
            expect_any_instance_of(LinesOfCode).to_not receive(:analyse)
            analyse_repository!
            expect(repository.commits.first.completed_analysers).to_not be_empty
          end
        end
      end
    end

    describe "todo" do
      # TODO this is a todo that will be caught by the TODO analyser
      it "has a TODO in this file" do
        expect(repository.commits.first.file_todos).to_not be_empty
      end

      it_behaves_like "does not capture .git files" do
        let(:commit_files) { repository.latest_commit.file_todos.map(&:commit_file).flatten }
      end

      context "when the TODO analyser has already run" do
        it "does not call the analyser again" do
          expect(repository.commits.first.completed_analysers).to_not be_empty
          expect_any_instance_of(CountTodos).to_not receive(:analyse)
          analyse_repository!
          expect(repository.commits.first.completed_analysers).to_not be_empty
        end

        context "when the original TODO analyser found zero results" do
          before do
            repository.commits.first.file_todos.delete_all
          end

          it "does not call the analyser again" do
            expect(repository.commits.first.completed_analysers).to_not be_empty
            expect_any_instance_of(CountTodos).to_not receive(:analyse)
            analyse_repository!
            expect(repository.commits.first.completed_analysers).to_not be_empty
          end
        end
      end
    end

    describe "fixme" do
      # FIXME this is a fixme that will be caught by the FIXME analyser
      it "has a FIXME in this file" do
        expect(repository.commits.first.file_fixmes).to_not be_empty
      end

      it_behaves_like "does not capture .git files" do
        let(:commit_files) { repository.latest_commit.file_fixmes.map(&:commit_file).flatten }
      end
    end

    describe "sass" do
      # this captures the stylesheets in templates/stylesheets/
      it "has some sass nodes for the latest commit" do
        expect(repository.latest_commit.file_sass_stylesheets).to_not be_empty
      end

      it_behaves_like "does not capture .git files" do
        let(:commit_files) { repository.latest_commit.file_sass_stylesheets.map(&:commit_file).flatten }
      end
    end

    describe "diffs" do
      it "has some diff nodes for the latest commit" do
        expect(repository.latest_commit.commit_diffs).to_not be_empty
      end

      it_behaves_like "does not capture .git files" do
        let(:commit_files) { repository.latest_commit.commit_diffs.map(&:commit_file).flatten }
      end
    end

    describe "count files" do
      let(:latest_commit) { repository.latest_commit }

      it "has files that we expect in the repository" do
        expect(latest_commit.commit_files).to_not be_empty
        expect(latest_commit.select_file("spec/integration/integration_spec.rb")).to_not be_nil
        expect(latest_commit.select_file("README.md")).to_not be_nil
        expect(latest_commit.select_file(".travis.yml")).to_not be_nil
      end
    end

    describe "file paths" do
      it "has at least one file path for the latest commit" do
        expect(repository.file_paths).to_not be_empty
      end

      it "has no file paths starting with .git" do
        expect(repository.file_paths.map(&:path).select { |path| path.include?(".git/") }).to be_empty
      end
    end

    describe "git blames" do
      it "has some git blame nodes for the latest commit" do
        expect(repository.latest_commit.git_blames).to_not be_empty
      end

      it_behaves_like "does not capture .git files" do
        let(:commit_files) { repository.latest_commit.git_blames.map(&:commit_file).flatten }
      end
    end

    describe "file ownership" do
      subject(:ownership) { repository.latest_commit.select_file(filename).file_ownership }

      describe ".travis.yml" do
        let(:filename) { ".travis.yml"}

        it "has 100% ownership" do
          expect(ownership).to_not be_empty
          expect(ownership["jevon@powershop.co.nz"]).to_not be_empty
          expect(ownership["jevon@powershop.co.nz"][:ownership]).to be > 0.5
        end
      end
    end

    describe "identifying tests within analysed repositories" do
      before do
        analyse_tests_repository!
      end

      it "creates a tests-only repository" do
        expect(repository.child_repositories.length).to eq 1
        expect(tests_repository.parent_repository).to eq repository
        expect(tests_repository.only_paths_matching).to include "test"
        expect(repository.tests_repository).to eq tests_repository

        expect(repository.is_tests_only?).to be false
        expect(tests_repository.is_tests_only?).to be true
      end

      describe "the tests repository" do
        describe "count files" do
          let(:latest_commit) { tests_repository.latest_commit }

          it "has files that we expect in the repository, but only of tests" do
            expect(latest_commit.commit_files).to_not be_empty
            expect(latest_commit.select_file("spec/integration/integration_spec.rb")).to_not be_nil
            expect(latest_commit.select_file("README.md")).to be_nil
            expect(latest_commit.select_file(".travis.yml")).to be_nil
          end
        end
      end
    end

    context "one of the files modified in the latest commit" do
      let(:file) { repository.latest_commit.commit_diffs.first.commit_file }
      let(:file_path) { file.full_path }

      it_behaves_like "does not capture .git files" do
        let(:commit_files) { repository.latest_commit.commit_files }
      end

      describe "contributors_for" do
        it "has one contributor for a changed file (since --limit is 1)" do
          expect(repository.latest_commit.commit_diffs).to_not be_empty, "There were not any diffs for commit #{repository.latest_commit.commit_hash}"
          expect(repository.contributors_for(file_path)).to eq(1)
        end

        it "has zero contributors for a file that has _not_ been changed in the last 1 commits" do
          expect(repository.contributors_for(".travis.yml")).to eq(0)
        end

        it "has zero contributors for a file that does not exist" do
          expect(repository.contributors_for("invalid file")).to eq(0)
        end
      end

      describe "revisions_for" do
        it "has two revisions for a changed file (since --limit is 1)" do
          expect(repository.latest_commit.commit_diffs).to_not be_empty, "There were not any diffs for commit #{repository.latest_commit.commit_hash}"
          expect(repository.revisions_for(file_path)).to eq(2)
        end

        it "has zero revisions for a file that has _not_ been changed in the last 1 commits" do
          expect(repository.revisions_for(".travis.yml")).to eq(0)
        end

        it "has zero revision for a file that does not exist" do
          expect(repository.revisions_for("invalid file")).to eq(0)
        end
      end
    end

    describe "options" do
      describe "limit = 2" do
        let(:options) {
          integration_options.merge({
            limit: 2,
          })
        }

        it "has analysed two commits" do
          expect(repository.commits.size).to eq(2)
          expect(repository.analysed_commits.size).to eq(2)
        end
      end

      describe "limit = 3, max = 1" do
        let(:options) {
          integration_options.merge({
            limit: 3,
            max: 1,
          })
        }

        it "has analysed only one commit out of 3 total" do
          expect(repository.analysed_commits.size).to eq(1), "analysed commits = #{repository.analysed_commits.map(&:subject)}"
          expect(repository.commits.size).to eq(3)
        end

        describe "and after running the analysis again" do
          before { analyse_repository! }

          it "has now analysed two commits out of 3 total" do
            expect(repository.analysed_commits.size).to eq(2)
            expect(repository.commits.size).to eq(3)
          end
        end
      end

      describe "max = 1" do
        let(:options) {
          integration_options.merge({
            limit: nil,
            max: 1,
          })
        }

        it "has analysed only one commit out of way more than 3 total" do
          expect(repository.analysed_commits.size).to eq(1), "analysed commits = #{repository.analysed_commits.map(&:subject)}"
          expect(repository.commits.size).to be > 3
        end
      end
    end
  end
end
