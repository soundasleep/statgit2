require "spec_helper"

describe AnalyseRepository, type: :service do
  let(:commit_0) { double(Commit, author_date: 0.days.ago) }
  let(:commit_3) { double(Commit, author_date: 3.days.ago) }
  let(:commit_3_1) { double(Commit, author_date: 3.days.ago + 1.hour) }
  let(:commit_3_2) { double(Commit, author_date: 3.days.ago + 2.hour) }
  let(:commit_4) { double(Commit, author_date: 4.days.ago) }
  let(:commit_5) { double(Commit, author_date: 5.days.ago) }

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
  let(:service) { AnalyseRepository.new(repository: repository) }

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
