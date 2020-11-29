require "octokit"

class Repo
  attr_reader :client
  attr_reader :repo_name

  ACCEPT_OPTIONS = Octokit::Preview::PREVIEW_TYPES.slice(:issue_timelines, :project_card_events).values

  def initialize(name)
    @repo_name = name
    @client = Octokit::Client.new(
      access_token: ENV["GITHUB_ACCESS_TOKEN"]
    )
  end

  def issues
    client.issues(repo_name accept: ACCEPT_OPTIONS)
  end

  def issue(num)
    client.issue(repo_name, num, accept: ACCEPT_OPTIONS)
  end

  def issue_timeline(num)
    client.issue_timeline(repo_name, num, accept: ACCEPT_OPTIONS)
  end
end
