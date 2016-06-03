require "spec_helper"

describe CommandLineHelper, type: :helper do
  include CommandLineHelper

  describe "#capture_output" do
    let(:test_string) { "Hello, world!" }

    it "captures output printed with `puts`" do
      output = capture_output do
        puts test_string
      end

      expect(output).to eq(test_string + "\n")
    end

    it "captures lots of output" do
      output = capture_output do
        puts test_string
        puts test_string
        puts test_string
      end

      expect(output).to eq((test_string + "\n") * 3)
    end
  end
end
