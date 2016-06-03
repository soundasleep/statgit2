module CommandLineHelper
  class CommandLineError < StandardError; end

  delegate :root_path, to: :repository

  def execute_command(command)
    temp_file = Tempfile.new(self.class.name)

    command += " 2>&1 > #{temp_file.path}"

    LOG.debug ">> #{command}"
    system(*command) or raise CommandLineError, "Command failed: #{$?}"

    output = temp_file.read

    if block_given?
      yield(output)
    else
      LOG.debug "(#{output.split("\n").length} lines)"
    end
  end

  def capture_output
    begin
      old_stdout = $stdout
      $stdout = StringIO.new('', 'w')
      yield
      $stdout.string
    ensure
      $stdout = old_stdout
    end
  end
end
