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

  describe "#execute_command" do
    it "can capture an echo" do
      output = []
      execute_command("echo hi") do |out|
        output << out
      end
      expect(output.map(&:strip)).to eq(["hi"])
      expect(output.first.split("\n")).to eq(["hi"])
    end

    it "can handle invalid UTF-8 by stripping it out" do
      temp = Tempfile.new("invalid_utf8")
      temp.write("test\xf0\x28\x8c\xbctest")
      temp.close

      output = []
      execute_command("cat \"#{temp.path}\"") do |out|
        output << out
      end
      expect(output.map(&:strip)).to eq(["test(test"])
      expect(output.first.split("\n")).to eq(["test(test"])
    end
  end
end
