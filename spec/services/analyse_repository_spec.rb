require "spec_helper"

describe AnalyseRepository, type: :service do
  let(:commit_0) { { author_date: Date.parse("2015-01-01") } }
  let(:commit_3) { { author_date: Date.parse("2015-01-03 10:00:00") } }
  let(:commit_3_1) { { author_date: Date.parse("2015-01-03 11:00:00") } }
  let(:commit_3_2) { { author_date: Date.parse("2015-01-03 12:00:00") } }
  let(:commit_4) { { author_date: Date.parse("2015-01-04") } }
  let(:commit_5) { { author_date: Date.parse("2015-01-05") } }

  let(:commits) {
    [
      commit_0,
      commit_3,
      commit_3_1,
      commit_3_2,
      commit_4,
      commit_5,
    ]
  }

  let(:repository) { }
  let(:service) { AnalyseRepository.new(repository: repository, options: nil) }

  describe "#commits_per_day" do
    subject { service.commits_per_day(commits, per_day) }

    context "just one per day" do
      let(:per_day) { 1 }
      let(:expected) { [ commit_0, commit_3, commit_4, commit_5 ] }

      it { is_expected.to eq(expected) }
    end

    context "just two per day" do
      let(:per_day) { 2 }
      let(:expected) { [ commit_0, commit_3, commit_3_1, commit_4, commit_5 ] }

      it { is_expected.to eq(expected) }
    end

    context "just five per day" do
      let(:per_day) { 5 }
      let(:expected) { commits }

      it { is_expected.to eq(expected) }
    end
  end
end
