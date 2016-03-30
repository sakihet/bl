require "thor"
require "backlog_kit"
require "bl/version"

module Bl
  class CLI < Thor
    desc "version", "show version"
    def version
      puts Bl::VERSION
    end

    desc "list", "list issues"
    def list
      issues = Bl::CLI.client.get('issues').body.each do |i|
        puts [
          i.issueType.name,
          i.issueKey,
          i.summary,
          i.priority.name,
          i.created,
          i.dueDate,
          i.updated,
          i.createdUser.name,
          i.assignee.name,
          i.status.name
        ].join("\t")
      end
    end

    desc "search QUERY", "search issues by QUERY"
    def search(query)
      issues = Bl::CLI.client.get('issues', keyword: query).body.each do |i|
        puts [
          i.issueType.name,
          i.issueKey,
          i.summary,
          i.priority.name,
          i.created,
          i.dueDate,
          i.updated,
          i.createdUser.name,
          i.assignee.name,
          i.status.name
        ].join("\t")
      end
    end

    desc "show KEY", "show an issue's details"
    def show(key)
      i = Bl::CLI.client.get("issues/#{key}")
      str = i.body.pretty_inspect
      puts str
    end

    def self.client
      BacklogKit::Client.new(
        space_id: ENV['BACKLOG_SPACE_ID'],
        api_key: ENV['BACKLOG_API_KEY']
      )
    end
  end
end

Bl::CLI.start(ARGV)
