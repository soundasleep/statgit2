class AbstractReport
  include ReportHelper

  attr_reader :repository

  def initialize(repository:)
    @repository = repository
  end

  def create_file!(name)
    Dir.mkdir(output_location) unless Dir.exist?(output_location)

    filename = output_location + file_for(name)
    output = render_output(name)
    bytes = File.write filename, output

    LOG.debug "Created #{filename} (#{bytes} bytes)"
  end

  def render_output(name)
    render_template(root_template, template_arguments) do
      render_template(template_for(name), template_arguments)
    end
  end

  def title
    self.class.title
  end

  def self.title
    self.class.name
  end

  def self.root_path
    self.class.name
  end

  def navigation
    ALL_REPORTS.select(&:public?).map do |report|
      [report.root_path + ".html", report.title]
    end
  end

  def self.public?
    false
  end

  private

  def output_location
    "output/"
  end

  def file_for(filename)
    "#{filename}.html"
  end

  def template_extension
    ".html.haml"
  end

  def template_for(filename)
    File.dirname(__FILE__) + "/../templates/#{simple_class_name}/#{filename}#{template_extension}"
  end

  def root_template
    File.dirname(__FILE__) + "/../templates/layouts/default#{template_extension}"
  end

  def simple_class_name
    self.class.name.underscore
  end

  def template_arguments
    {
      repository: repository,
    }
  end
end
