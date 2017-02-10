require "action_view"
require_relative "date_helper"
require_relative "number_helper"

module ReportHelper
  include DateHelper
  include NumberHelper
  include ActionView::Helpers::UrlHelper

  def commit_link(commit)
    if options[:commit_path]
      link_to(commit.commit_hash, options[:commit_path] + commit.commit_hash)
    else
      commit.commit_hash
    end
  end

  def blob_link(filename)
    if options[:blob_path]
      link_to(filename, options[:blob_path] + filename)
    else
      filename
    end
  end

  def wrap_array(data)
    if data.is_a?(Array)
      data
    else
      [data]
    end
  end

  def render_chart(chart_type, repository, method, title, options = {})
    data = nil

    benchmark = Benchmark.realtime do
      data = repository.send(method).map do |key, value|
        if value.nil? || (value.is_a?(Float) && value.nan?)
          nil
        else
          [key, wrap_array(value)]
        end
      end.compact
    end

    data = Hash[data]

    labels = wrap_array(title)

    options = {
      width: 600,
      height: 400,
    }.merge(options)

    arguments = template_arguments.merge(options).merge({
      benchmark: benchmark,
      data: data,
      labels: labels,
      title: title,
      method: method,
    })

    render_template(shared_template(chart_type), arguments)
  end

  def scatter_chart(repository, method, title, options = {})
    render_chart "scatter_chart", repository, method, title, options
  end

  def line_chart(repository, method, title, options = {})
    render_chart "line_chart", repository, method, title, options
  end

  def large_line_chart(repository, method, title, options = {})
    line_chart(repository, method, title, {width: 800, height: 600}.merge(options))
  end

  def pie_chart(repository, method, title, options = {})
    render_chart "pie_chart", repository, method, title, {width: 400, height: 300}.merge(options)
  end

  def histogram_chart(repository, method, heading, title, options = {})
    render_chart "histogram_chart", repository, method, title, {heading: heading}.merge(options)
  end

  def table(repository, method, labels, limit = 30, options = {})
    data = nil
    benchmark = Benchmark.realtime do
      data = repository.send(method).first(limit)
    end

    arguments = template_arguments.merge(options).merge({
      benchmark: benchmark,
      data: data,
      labels: labels,
      limit: limit,
      method: method,
    })

    render_template(shared_template("table"), arguments)
  end

  def render_template(template, template_arguments)
    engine = Haml::Engine.new(File.read(template))
    engine.render self, template_arguments do
      yield
    end
  end

  def shared_template(key)
    File.dirname(__FILE__) + "/../templates/shared/#{key}.html.haml"
  end

  def link_for(report, selector = nil)
    report.new(repository: repository).hyperlink(selector)
  end
end
