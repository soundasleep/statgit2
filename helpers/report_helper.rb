require "action_view"

module ReportHelper
  include ActionView::Helpers::UrlHelper

  def commit_link(commit)
    link_to(commit.commit_hash, "#")
  end

  def date(date)
    date.to_formatted_s(:db)
  end
end
