require_relative "issue"
require_relative "timeline"

class ProjectTask
  attr_reader :repo, :num

  Report = Struct.new(
    :number, :title,
    :accept_at_str, :done_at_str,
    :diff_str
  )

  def initialize(repo, num)
    @repo = repo
    @num = num
  end

  def report
    return @report if defined?(@report)

    @report = Report.new(
      issue.number,
      issue.title,
      timeline.accept_at_str,
      timeline.done_at_str,
      timeline.diff_str,
    )
  end

  def timeline
    @timeline ||= Timeline.new(repo.issue_timeline(num)).report
  end

  def issue
    @issue ||= Issue.new(repo.issue(num)).report
  end
end
