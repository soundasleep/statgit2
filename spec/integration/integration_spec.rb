require "spec_helper"

connect_to_database

describe "Integration tests", type: :integration do
  let(:url) { "https://github.com/soundasleep/statgit2" }
  let(:options) {
    default_options.merge({
      url: url,
      limit: 1,
    })
  }

  before do
    @repository = CreateRepository.new(options: options).call
    AnalyseRepository.new(repository: repository, options: options).call
  end

  def repository
    @repository
  end

  describe "cloc" do
    it "has initialized the database with a single commit" do
      expect(repository.commits).to_not be_empty
      expect(repository.commits.size).to eq(1)
    end

    it "has files for that commit" do
      expect(repository.commits.first.files).to_not be_empty
    end
  end
end
