require "octokit"
require_relative "project"
require_relative "project_task"

class Repo
  attr_reader :client
  attr_reader :repo_name

  ACCEPT_OPTIONS = Octokit::Preview::PREVIEW_TYPES.slice(:issue_timelines, :projects, :project_card_events).values

  def initialize(name)
    @repo_name = name
    @client = Octokit::Client.new(
      access_token: ENV["GITHUB_ACCESS_TOKEN"],
      default_media_type: ACCEPT_OPTIONS
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

  def project_list
    projects.map do |pj|
      [pj.number, pj.name]
    end
  end

  def project(num)
    projects.detect do |pj|
      pj[:number] == num
    end
  end

  def project_columns(project_id)
    client.project_columns(project_id, accept: ACCEPT_OPTIONS)
  end

  def column_cards(column_id)
    client.column_cards(column_id, accept: ACCEPT_OPTIONS)
  end

  def projects
    @projects ||= client.projects(repo_name, {state: :all, accept: ACCEPT_OPTIONS})
  end
end
