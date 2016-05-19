class AbstractReport
  attr_reader :repository

  def initialize(repository:)
    @repository = repository
  end

  def create_file!(name)
    Dir.mkdir "output/" unless Dir.exist?("output/")

    @template ||= Haml::Engine.new(File.read(root_template))
    filename = file_for(name)

    LOG.info "Creating #{filename}..."
    engine = Haml::Engine.new(File.read(template_for(name)))
    output = @template.render self, template_arguments do
      engine.render self, template_arguments
    end

    bytes = File.write filename, output
    LOG.debug "(#{bytes} bytes)"
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
    ALL_REPORTS.map do |report|
      [report.root_path + ".html", report.title]
    end
  end

  private

  def file_for(filename)
    "output/#{filename}.html"
  end

  def template_for(filename)
    File.dirname(__FILE__) + "/#{simple_class_name}/#{filename}.html.haml"
  end

  def root_template
    File.dirname(__FILE__) + "/layouts/default.html.haml"
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
