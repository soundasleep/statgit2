require "spec_helper"

describe "Integration tests", type: :integration do
  let(:url) { "https://github.com/soundasleep/statgit2" }
  let(:workspace) { Dir.tmpdir }
  let(:database_dir) { Dir.tmpdir }
  let(:database) { "#{database_dir}/database" }
  let(:integration_options) {
    default_options.merge({
      url: url,
      limit: 1,
      level: "error",
      workspace: workspace,
      database: database,
    })
  }
  let(:options) { integration_options }

  def reset_workspace!
    if Dir.exist?(workspace)
      LOG.info "Resetting workspace #{workspace}"
      FileUtils.rm_r(workspace)
    end
    Dir.mkdir(workspace)

    if File.exist?(database)
      LOG.info "Resetting database #{database}"
      File.delete(database)
    end

    connect_to_database(options)
    @repository = CreateRepository.new(options: options).call
  end

  def analyse_repository!
    AnalyseRepository.new(repository: repository, options: options).call
  end

  def repository
    @repository
  end

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
    end

    describe "sass" do
      it "has some sass nodes for the latest commit" do
        expect(repository.commits.last.file_sass_stylesheets).to_not be_empty
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
    end
  end
end
