require "spec_helper"

describe DateHelper, type: :helper do
  include DateHelper

  let(:date) { Time.parse("2016-01-01 11:12:13 +0800") }

  describe "#iso_date" do
    subject { iso_date(date) }

    it { is_expected.to eq("2016-01-01") }
  end

  describe "#minute_date" do
    subject { minute_date(date) }

    it { is_expected.to eq("2016-01-01 11:12") }
  end

  describe "#day_name" do
    subject { day_name(date) }

    it { is_expected.to eq("Fri") }
  end

  describe "#time_zone" do
    subject { time_zone.name }

    it { is_expected.to eq("UTC") }

    context "with options[timezone] = 'Auckland'" do
      def options
        {
          timezone: "Auckland"
        }
      end

      it { is_expected.to eq("Auckland") }
    end
  end
end
