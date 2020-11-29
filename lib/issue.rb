class Issue
  attr_reader :issue

  Report = Struct.new(
    :number,
    :title,
  )

  def initialize(issue_response)
    @issue = issue_response
  end

  def report
    @report ||= Report.new(
      issue.number,
      issue.title,
    )
  end
end
