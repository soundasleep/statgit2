require "spec_helper"

describe NumberHelper, type: :helper do
  include NumberHelper

  describe "#kb_size" do
    it "formats numbers" do
      expect(kb_size(1)).to eq("0.00 KB")
      expect(kb_size(1024)).to eq("1.00 KB")
      expect(kb_size(2048)).to eq("2.00 KB")
      expect(kb_size(1024 ** 2)).to eq("1,024.00 KB")
    end
  end

  describe "#float_number" do
    it "formats numbers" do
      expect(float_number(1)).to eq("1.00")
      expect(float_number(1.000001)).to eq("1.00")
      expect(float_number(1024.34)).to eq("1,024.34")
    end
  end
end
