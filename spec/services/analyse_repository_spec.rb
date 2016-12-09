require "spec_helper"

describe AnalyseRepository, type: :service do
  let(:commit_0) { { author_date: Date.parse("2015-01-01"), commit_hash: "first" } }
  let(:commit_3) { { author_date: Date.parse("2015-01-03 10:00:00"), commit_hash: "second" } }
  let(:commit_3_1) { { author_date: Date.parse("2015-01-03 11:00:00"), commit_hash: "third" } }
  let(:commit_3_2) { { author_date: Date.parse("2015-01-03 12:00:00"), commit_hash: "fourth" } }
  let(:commit_4) { { author_date: Date.parse("2015-01-04"), commit_hash: "fifth" } }
  let(:commit_5) { { author_date: Date.parse("2015-01-05"), commit_hash: "sixth" } }

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

  describe "#commits_between" do
    subject { service.commits_between(commits, from, to) }

    context "without a 'from'" do
      let(:from) { nil }

      context "without a 'to'" do
        let(:to) { nil }
        let(:expected) { commits }

        it { is_expected.to eq(expected) }
      end

      context "with 'to' set to 'third'" do
        let(:to) { "third" }
        let(:expected) { [ commit_0, commit_3, commit_3_1 ] }

        it { is_expected.to eq(expected) }

        context "and 'third' is abbreviated" do
          let(:to) { "thi" }

          it { is_expected.to eq(expected) }
        end
      end

      context "with an invalid 'to'" do
        let(:to) { "invalid" }
        let(:expected) { [] }

        it { is_expected.to eq(expected) }
      end
    end

    context "with 'from' set to 'third'" do
      let(:from) { "third" }

      context "without a 'to'" do
        let(:to) { nil }
        let(:expected) { [ commit_3_1, commit_3_2, commit_4, commit_5 ] }

        it { is_expected.to eq(expected) }

        context "and 'third' is abbreviated" do
          let(:from) { "thi" }

          it { is_expected.to eq(expected) }
        end
      end

      context "with 'to' set to 'fifth'" do
        let(:to) { "fifth" }
        let(:expected) { [ commit_3_1, commit_3_2, commit_4 ] }

        it { is_expected.to eq(expected) }
      end

      context "with 'to' set to 'third'" do
        let(:to) { from }
        let(:expected) { [ commit_3_1 ] }

        it { is_expected.to eq(expected) }
      end

      context "with 'to' set to 'first'" do
        let(:to) { "first" }
        let(:expected) { [] }

        it { is_expected.to eq(expected) }
      end
    end

    context "with an invalid 'from'" do
      let(:from) { "invalid" }
      let(:to) { "third" }
      let(:expected) { [] }

      it { is_expected.to eq(expected) }
    end
  end
end
