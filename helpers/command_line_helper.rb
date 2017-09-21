module CommandLineHelper
  class CommandLineError < StandardError; end

  def root_path
    options[:workspace]
  end

  # Run the command, load the results into memory, then pass the entire block
  def execute_command(command)
    temp_file = Tempfile.new(self.class.name)

    command += " 2>&1 > #{temp_file.path}"

    LOG.debug ">> #{command}"
    system(*command) or raise CommandLineError, "Command failed: #{$?}"

    output = temp_file.read

    if block_given?
      # remove any invalid UTF-8 symbols
      yield strip_invalid_utf8(output)
    else
      LOG.debug "(#{output.split("\n").length} lines)"
    end
  end

  # Run the command, but stream the results to the given block
  def stream_command(command)
    LOG.debug ">> #{command} (stream)"
    IO.popen(command) do |io|
      while line = io.gets
        yield strip_invalid_utf8(line)
      end
    end
    raise CommandLineError, "Command failed: #{$?}" unless $?.to_i == 0
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

  def all_files_in(root_path)
    Dir.glob("#{root_path}{,**/}*", File::FNM_DOTMATCH).reject do |path|
      path.ends_with?("/.") || path.ends_with?("/..") || path.include?("/.git/") || path.end_with?("/.git")
    end
  end

  def strip_invalid_utf8(string)
    string.encode("utf-8", invalid: :replace, undef: :replace, replace: "")
  end

  def binary_file?(file_path)
    !! file_path.match(/\.(png|gif|jpg|jpeg|pdf|exe|bin|sqlite3|db)$/)
  end
end
