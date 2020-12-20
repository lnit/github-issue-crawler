require_relative "project_task"

class Project
  attr_reader :repo, :num

  def initialize(repo, num)
    @repo = repo
    @num = num
  end

  def done_issues
    done_issue_numbers = done_cards.map do |card|
      if (card.content_url =~ /issues\/([0-9]*)/)
        $1
      end
    end.compact

    done_issue_numbers.map do |num|
      ProjectTask.new(repo, num)
    end
  end

  def report
    done_issues.map(&:report)
  end

  private

  def done_cards
    repo.column_cards(done_column.id)
  end

  def done_column
    @done_columns ||= repo.project_columns(project.id).detect do |c|
      c.name =~ /done/i
    end
  end

  def project
    @project = repo.project(num)
  end
end
