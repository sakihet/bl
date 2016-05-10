module Bl

  class CLI < Thor
    include Bl::Requestable
    include Bl::Formatting

    ISSUE_BASE_ATTRIBUTES = {
      summary: :string,
      description: :string,
      statusId: :numeric,
      resolutionId: :numeric,
      dueDate: :string,
      issueTypeId: :numeric,
      categoryId: :array,
      versionId: :array,
      milestoneId: :array,
      priorityId: :numeric,
      assigneeId: :numeric
    }

    def initialize(*)
      @config = Bl::Config.instance
      super
    end

    desc 'version', 'show version'
    def version
      puts Bl::VERSION
    end

    desc 'config', 'show config'
    def config
      p @config
    end

    desc 'init', 'initialize a default config file'
    def init
      filename = File.join(Dir.home, Bl::CONFIG_FILE)
      if File.exist?(filename)
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

    desc 'count', 'count issues'
    def count
      puts client.get('issues/count').body.count
    end

    desc 'list', 'list issues'
    option :all, type: :boolean
    option :unassigned, type: :boolean
    option :today, type: :boolean
    option :overdue, type: :boolean
    option :priority, type: :boolean
    def list
      opts = {}
      opts[:statusId] = [1, 2, 3] unless options[:all]
      opts[:assigneeId] = [-1] if options[:unassigned]
      if options[:today]
        opts[:dueDateSince] = Date.today.to_s
        opts[:dueDateUntil] = Date.today.next.to_s
      end
      opts[:dueDateUntil] = Date.today.to_s if options[:overdue]
      if options[:priority]
        opts[:sort] = "priority"
        opts[:order] = "asc"
      end
      client.get('issues', opts).body.each do |i|
        puts [
          colorize_type(i.issueType.name, i.issueType.color),
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

    desc 'search', 'search issues'
    option :keyword
    option :categoryId, type: :array
    option :assigneeId, type: :array
    def search
      client.get('issues', options.to_h).body.each do |i|
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

    desc 'show KEY', "show an issue's details"
    def show(key)
      body = client.get("issues/#{key}").body
      puts "type: #{body.issueType.name}"
      puts "key: #{body.issueKey}"
      puts "created: #{body.created}"
      puts "due date: #{body.dueDate}"
      puts "summary: #{body.summary}"
      puts "priority: #{body.priority.name}"
      puts "category: #{body.category}"
      puts "resolution: #{body.resolution}"
      puts "version: #{body.versions}"
      puts "status: #{body.status.name}"
      puts "milestone: #{body.milestone}"
      puts "assignee: #{body.assignee.name}"
      puts "created user: #{body.createdUser.name}"
      puts '--'
      puts "description:"
      puts body.description
    end

    desc 'browse KEY', 'browse an issue'
    def browse(key)
      url = 'https://' + @config[:space_id] + '.backlog.jp/view/' + key
      system("open #{url}")
    end

    desc 'add [SUBJECT...]', 'add issues'
    options ISSUE_BASE_ATTRIBUTES
    def add(*subjects)
      subjects.each do |s|
        base_options = {
          projectId: @config[:issue][:default_project_id].to_i,
          summary: s,
          issueTypeId: @config[:issue][:default_issue_type_id].to_i,
          priorityId: @config[:issue][:default_priority_id].to_i
        }
        res = client.post(
          'issues',
          base_options.merge(options)
        )
        puts "issue added: #{res.body.issueKey}\t#{res.body.summary}"
      end
    end

    desc 'update [KEY...]', 'update issues'
    options ISSUE_BASE_ATTRIBUTES
    option :comment, type: :string
    def update(*keys)
      keys.each do |k|
        res = client.patch("issues/#{k}", options.to_h)
        puts "issue updated: #{res.body.issueKey}\t#{res.body.summary}"
      end
    end

    desc 'close [KEY...]', 'close issues'
    def close(*keys)
      keys.each do |k|
        res = client.patch("issues/#{k}", statusId: 4)
        puts "issue closed: #{res.body.issueKey}\t#{res.body.summary}"
      end
    end

    desc 'statuses', 'list statuses'
    def statuses
      client.get('statuses').body.each do |s|
        puts [s.id, s.name].join("\t")
      end
    end

    desc 'priorities', 'list priorities'
    def priorities
      client.get('priorities').body.each do |p|
        puts [p.id, p.name].join("\t")
      end
    end

    desc 'resolutions', 'list resolutions'
    def resolutions
      client.get('resolutions').body.each do |r|
        puts [r.id, r.name].join("\t")
      end
    end

    desc 'users', 'list space users'
    def users
      client.get('users').body.each do |u|
        puts [u.id, u.userId, u.name, u.roleType, u.lang, u.mailAddress].join("\t")
      end
    end

    desc 'activities', 'list activities'
    def activities
      client.get('/space/activities').body.each do |a|
        puts a.pretty_inspect
      end
    end

    desc 'type SUBCOMMAND ...ARGS', 'manage types'
    subcommand 'type', Type

    desc 'category SUBCOMMAND ...ARGS', 'manage categoryies'
    subcommand 'category', Category

    desc 'milestone SUBCOMMAND ...ARGS', 'manage milestones'
    subcommand 'milestone', Milestone

    desc 'wiki SUBCOMMAND ...ARGS', 'manage wikis'
    subcommand 'wiki', Wiki

    desc 'project SUBCOMMAND ...ARGS', 'manage projects'
    subcommand 'project', Project
  end
end
