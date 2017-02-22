require "spec_helper"

describe DateHelper, type: :helper do
  include DateHelper

  let(:date) { Time.parse("2016-01-01 11:12:13 +0800") }

  describe "#iso_date" do
    subject { iso_date(date) }

    it { is_expected.to eq("2016-01-01") }

    it "formats nil" do
      expect(iso_date(nil)).to eq("")
    end
  end

  describe "#minute_date" do
    subject { minute_date(date) }

    it { is_expected.to eq("2016-01-01 11:12") }

    it "formats nil" do
      expect(minute_date(nil)).to eq("")
    end
  end

  describe "#month_date" do
    subject { month_date(date) }

    it { is_expected.to eq("2016-01") }

    it "formats nil" do
      expect(iso_date(nil)).to eq("")
    end
  end

  describe "#day_name" do
    subject { day_name(date) }

    it { is_expected.to eq("Fri") }

    it "formats nil" do
      expect(day_name(nil)).to eq("")
    end
  end

  describe "#time_zone" do
    subject { time_zone.name }

    context "with default options" do
      def options
        default_options
      end

      it { is_expected.to eq("UTC") }
    end

    context "with options[timezone] = 'Auckland'" do
      def options
        {
          timezone: "Auckland",
        }
      end

      it { is_expected.to eq("Auckland") }
    end
  end
end
