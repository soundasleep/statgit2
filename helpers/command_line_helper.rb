module CommandLineHelper
  class CommandLineError < StandardError; end

  def root_path
    options[:workspace]
  end

  def execute_command(command)
    temp_file = Tempfile.new(self.class.name)

    command += " 2>&1 > #{temp_file.path}"

    LOG.debug ">> #{command}"
    system(*command) or raise CommandLineError, "Command failed: #{$?}"

    output = temp_file.read

    if block_given?
      # remove any invalid UTF-8 symbols
      yield(output.encode("utf-8", invalid: :replace, undef: :replace, replace: ""))
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

  def all_files_in(root_path)
    Dir.glob("#{root_path}{,**/}*", File::FNM_DOTMATCH).reject do |path|
      path.ends_with?("/.") || path.ends_with?("/..") || path.include?("/.git/")
    end
  end
end
