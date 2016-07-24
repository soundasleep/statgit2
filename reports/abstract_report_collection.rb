require_relative 'abstract_report'

class AbstractReportCollection < AbstractReport
  def generate!
    # generate root .html
    super

    # and all of the smaller .htmls
    all_reports.each do |report|
      create_file! root_path, report
    end
  end

  def root_path_for(report)
    title.downcase + "_" + report
  end
end
