require "sass"

class Stylesheet < AbstractReport
  def generate!
    create_file! "default"
  end

  def file_for(filename)
    "#{filename}.css"
  end

  def render_output(name)
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
