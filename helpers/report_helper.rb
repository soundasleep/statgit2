require "action_view"
require "haml"

module ReportHelper
  include DateHelper
  include NumberHelper
  include FileHelper
  include ActionView::Helpers::UrlHelper

  class ReportRenderError < StandardError; end

  def commit_link(commit)
    if options[:commit_path]
      link_to(commit.commit_hash, options[:commit_path] + commit.commit_hash)
    else
      commit.commit_hash
    end
  end

  def blob_link(filename, html_options = {})
    if options[:blob_path]
      link_to(filename, options[:blob_path] + filename, html_options)
    else
      content_tag(:span, filename, html_options)
    end
  end

  def wrap_array(data)
    if data.respond_to?(:each)
      data
    else
      [data]
    end
  end

  def render_chart(chart_type, repository, methods, title, options = {})
    LOG.debug "Rendering chart '#{chart_type}' on #{methods} (#{title})" if LOG.debug?

    data = {}
    methods = wrap_array(methods)

    benchmark = Benchmark.realtime do
      methods.each.with_index do |submethod, index|
        repository.send(submethod).map do |key, value|
          if value.nil? || (value.is_a?(Float) && value.nan?)
            # ignore
          else
            if !data.has_key?(key)
              data[key] = methods.map { |_| nil }
            end
            data[key][index] = value
          end
        end
      end
    end

    options = {
      width: 600,
      height: 400,
    }.merge(options)

    arguments = template_arguments.merge(options).merge({
      benchmark: benchmark,
      data: data,
      title: title,
      methods: methods,
      div_name: "#{chart_type}_#{Random.rand(0xffff)}",
      method_name: "render_#{chart_type}_#{Random.rand(0xffff)}",
    })

    render_template(shared_template(chart_type), arguments)
  end

  def scatter_chart(repository, method, title:, options: {})
    render_chart "scatter_chart", repository, method, title, options
  end

  def line_chart(repository, method, labels:, title:, options: {})
    render_chart "line_chart", repository, method, title, labels_options(labels).merge(options)
  end

  def stacked_line_chart(repository, method, labels:, title:, options: {})
    render_chart "stacked_line_chart", repository, method, title, labels_options(labels).merge(options)
  end

  def pie_chart(repository, method, title:, options: {})
    render_chart "pie_chart", repository, method, title, {width: 400, height: 300}.merge(options)
  end

  def histogram_chart(repository, method, labels:, title:, options: {})
    render_chart "histogram_chart", repository, method, title, labels_options(labels).merge(options)
  end

  def large_histogram_chart(repository, method, labels:, title:, options: {})
    histogram_chart(repository, method, labels: labels, title: title, options: {width: 800, height: 600}.merge(options))
  end

  def labels_options(labels)
    {
      labels: wrap_array(labels),
      vertical_labels: labels.respond_to?(:each) ? "Count" : labels,
      stacked: false,
    }
  end

  def table(repository, method, labels:, limit: 30, options: {})
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
    begin
      LOG.debug "Rendering template '#{template}'" if LOG.debug?
      engine = Haml::Engine.new(File.read(template))
      template_arguments[:arguments] = template_arguments # for reference in partials
      engine.render self, template_arguments do
        yield
      end
    rescue ArgumentError => e
      raise ReportRenderError, "Could not render '#{template}': #{e}"
    end
  end

  def shared_template(key)
    File.dirname(__FILE__) + "/../templates/shared/#{key}.html.haml"
  end

  def render_partial(template, arguments)
    render_template shared_template(template), arguments
  end

  def link_for(report, selector = nil)
    report.new(repository: repository).hyperlink(selector)
  end
end
