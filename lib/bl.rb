require "thor"
require "backlog_kit"
require "bl/version"
require "yaml"
require "pp"

module Bl
  CONFIG_FILE = '.bl.yml'

  class CLI < Thor
    @@config = YAML.load_file(File.join(Dir.home, CONFIG_FILE))

    desc "version", "show version"
    def version
      puts Bl::VERSION
    end

    desc "config", "show config"
    def config
      puts @@config
    end

    desc "init", "initialize a default config file"
    def init
      filename = File.join(Dir.home, CONFIG_FILE)
      if File.exists?(filename)
        puts "#{filename} exits."
      else
        config = {
          space_id: '',
          api_key: '',
          project_key: '',
          issue: {
            default_project_id: '',
            default_issue_type_id: '',
            default_priority_id: ''
          }
        }
        f = File.new(filename, 'w')
        f.write(config.to_yaml)
        puts "#{filename} generated."
      end
    end

    desc "count", "count issues"
    def count
      puts Bl::CLI.client.get('issues/count').body.count
    end

    desc "list", "list issues"
    option :all, type: :boolean
    option :assigneeId, type: :array
    def list
      opts = {}
      if options[:all]
      else
        opts[:statusId] = [1, 2, 3]
      end
      issues = Bl::CLI.client.get('issues', opts.merge(options)).body
      issues.each do |i|
        puts [
          i.issueType.name,
          i.issueKey,
          i.summary,
          i.priority.name,
          i.created,
          i.dueDate,
          i.updated,
          i.createdUser.name,
          i.assignee&.name,
          i.status.name
        ].join("\t")
      end
    end

    desc "search", "search issues"
    option :keyword
    option :categoryId, type: :array
    def search
      issues = Bl::CLI.client.get('issues', options.to_h).body.each do |i|
        puts [
          i.issueType.name,
          i.issueKey,
          i.summary,
          i.priority.name,
          i.created,
          i.dueDate,
          i.updated,
          i.createdUser.name,
          i.assignee&.name,
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

    desc "add SUBJECT", "add an issue"
    def add(subject)
      Bl::CLI.client.post(
        "issues",
        projectId: @@config[:issue][:default_project_id].to_i,
        summary: subject,
        issueTypeId: @@config[:issue][:default_issue_type_id].to_i,
        priorityId: @@config[:issue][:default_priority_id].to_i
      )
    end

    desc "close KEY", "close an issue"
    def close(key)
      Bl::CLI.client.patch("issues/#{key}", statusId: 4)
      issue = Bl::CLI.client.get("issues/#{key}")
      puts "issue closed: #{issue.body.issueKey}\t#{issue.body.summary}"
    end

    desc "projects", "list projects"
    def projects
      projects = Bl::CLI.client.get('projects').body.each do |p|
        puts [p.id, p.projectKey, p.name].join("\t")
      end
    end

    desc "types", "list issue types"
    def types
      types = Bl::CLI.client.get("projects/#{@@config[:project_key]}/issueTypes").body.each do |t|
        puts [t.id, t.name].join("\t")
      end
    end

    desc "categories", "list issue categories"
    def categories
      categories = Bl::CLI.client.get("projects/#{@@config[:project_key]}/categories").body.each do |c|
        puts [c.id, c.name].join("\t")
      end
    end

    desc "statuses", "list statuses"
    def statuses
      statuses = Bl::CLI.client.get("statuses").body.each do |s|
        puts [s.id, s.name].join("\t")
      end
    end

    desc "priorities", "list priorities"
    def priorities
      priorities = Bl::CLI.client.get("priorities").body.each do |p|
        puts [p.id, p.name].join("\t")
      end
    end

    desc "resolutions", "list resolutions"
    def resolutions
      resolutions = Bl::CLI.client.get("resolutions").body.each do |r|
        puts [r.id, r.name].join("\t")
      end
    end

    desc 'users', 'list space users'
    def users
      users = Bl::CLI.client.get('users').body.each do |u|
        puts [u.id, u.userId, u.name, u.roleType, u.lang, u.mailAddress].join("\t")
      end
    end

    def self.client
      BacklogKit::Client.new(
        space_id: @@config[:space_id],
        api_key: @@config[:api_key]
      )
    end
  end
end

Bl::CLI.start(ARGV)
