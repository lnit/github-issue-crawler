require_relative "lib/repo"
require_relative "lib/project_task"
require_relative "lib/timeline"
require 'pry'

def repo
  @repo
end

def output_result(target)
  case target
  when Integer
    Project.new(repo, target).to_spread_sheet
  when Enumerable
    target.each { |t| output_result(t) }
  else
    raise ArgumentError
  end
end

puts "Input repository name (owner/name)"
repo_name = gets.chomp
@repo = Repo.new(repo_name)

puts "#{repo_name} project list"
repo.project_list.reverse.each do |pj|
  puts pj.join(" | ")
end

# usage example:
# output_result(1)
# output_result(1..2)
# output_result([1, 5..10])
binding.pry
