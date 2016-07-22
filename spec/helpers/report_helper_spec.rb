require "spec_helper"

describe ReportHelper, type: :helper do
  include ReportHelper

  def repository
    instance_double(Repository)
  end

  describe "#link_for" do
    subject { link_for(report) }

    context "for AuthorsReport" do
      let(:report) { AuthorsReport }

      it { is_expected.to eq("authors.html") }

      it "has a valid report" do
        expect(report.new(repository: repository)).to be_public
      end
    end

    context "for FilesReport" do
      let(:report) { FilesReport }

      it { is_expected.to eq("files.html") }
    end
  end
end
