require "sass"

class Stylesheet < AbstractReport
  def file_for(filename, selector = nil)
    "#{filename}.css"
  end

  def root_path
    "default"
  end

  def render_output(name, selector = nil)
    Sass::Engine.for_file(template_for(name), sass_options).render
  end

  def sass_options
    {
      syntax: :scss,
    }
  end

  def template_extension
    ".scss"
  end
end

ALL_REPORTS << Stylesheet
