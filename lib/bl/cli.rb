module Bl

  class CLI < Thor
    include Bl::Requestable
    include Bl::Formatting

    ISSUES_PARAMS = {
      projectId: :array,
      issueTypeId: :array,
      categoryId: :array,
      versionId: :array,
      milestoneId: :array,
      statusId: :array,
      priorityId: :array,
      assigneeId: :array,
      createdUserId: :array,
      resolutionId: :array,
      parentChild: :numeric,
      attachment: :boolean,
      sharedFile: :boolean,
      sort: :string,
      order: :string,
      offset: :numeric,
      count: :numeric,
      createdSince: :string,
      createUntil: :string,
      updatedSince: :string,
      updatedUntil: :string,
      startDateSince: :string,
      startDateUntil: :string,
      dueDateSince: :string,
      dueDateUntil: :string,
      id: :array,
      parentIssueId: :array,
      keyword: :string
    }

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

    ACTIVITY_TYPES = {
      1 => 'Issue Created',
      2 => 'Issue Updated',
      3 => 'Issue Commented',
      4 => 'Issue Deleted',
      5 => 'Wiki Created',
      6 => 'Wiki Updated',
      7 => 'Wiki Deleted',
      8 => 'File Added',
      9 => 'File Updated',
      10 => 'File Deleted',
      11 => 'SVN Committed',
      12 => 'Git Pushed',
      13 => 'Git Repository Created',
      14 => 'Issue Multi Updated',
      15 => 'Project User Added',
      16 => 'Project User Deleted',
      17 => 'Comment Notification Added',
      18 => 'Pull Request Added',
      19 => 'Pull Request Updated',
      20 => 'Comment Added on Pull Request'
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
        config = Bl::Config.instance.default_config
        f = File.new(filename, 'w')
        f.write(config.to_yaml)
        puts "#{filename} generated."
      end
    end

    desc 'space', 'show space info'
    def space
      res = client.get('space').body
      puts res.inspect
    end

    desc 'count', 'count issues'
    options ISSUES_PARAMS
    def count
      puts client.get('issues/count', options.to_h).body.count
    end

    desc 'list', 'list issues by typical ways'
    option :all, type: :boolean
    option :unassigned, type: :boolean
    option :today, type: :boolean
    option :overdue, type: :boolean
    option :priority, type: :boolean
    option :nocategory, type: :boolean
    def list
      opts = {}
      opts[:statusId] = [1, 2, 3] unless options[:all]
      opts[:assigneeId] = [-1] if options[:unassigned]
      if options[:today]
        today = Date.today
        opts[:dueDateSince] = today.to_s
        opts[:dueDateUntil] = today.next.to_s
      end
      opts[:dueDateUntil] = Date.today.to_s if options[:overdue]
      if options[:priority]
        opts[:sort] = "priority"
        opts[:order] = "asc"
      end
      opts[:categoryId] = [-1] if options[:nocategory]
      client.get('issues', opts).body.map {|i| print_issue(i)}
    end

    desc 'search', 'search issues'
    options ISSUES_PARAMS
    def search
      client.get('issues', options.to_h).body.map {|i| print_issue(i)}
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
        issue_default_options = @config[:issue][:default]
        res = client.post(
          'issues',
          issue_default_options.merge({summary: s}).merge(options)
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
        puts [s.id, colorize_status(s.id, s.name)].join("\t")
      end
    end

    desc 'priorities', 'list priorities'
    def priorities
      client.get('priorities').body.each do |p|
        puts [p.id, colorize_priority(p.id, p.name)].join("\t")
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
        puts [
          ACTIVITY_TYPES[a.type],
          a.content.inspect,
          a.createdUser.name,
          a.created
        ].join("\t")
      end
    end

    desc 'notifications', 'list notifications'
    def notifications
      client.get('notifications').body.each do |n|
        puts n.pretty_inspect
      end
    end

    desc 'doctor', 'check issues'
    def doctor
      unassigned_issues = client.get('issues', {assigneeId: [-1]}).body
      overdue_issues = client.get(
        'issues',
        statusId: [1, 2, 3],
        dueDateUntil: Date.today.to_s,
      ).body
      unless unassigned_issues.empty?
        puts 'warning: unassigned issues found.'
        puts 'issues:'
        unassigned_issues.map {|i| print_issue(i)}
      end
      unless overdue_issues.empty?
        puts 'warning: overdue issues found.'
        puts 'issues:'
        overdue_issues.map {|i| print_issue(i)}
      end
    end

    desc 'type SUBCOMMAND ...ARGS', 'manage types'
    subcommand 'type', Type

    desc 'category SUBCOMMAND ...ARGS', 'manage categories'
    subcommand 'category', Category

    desc 'milestone SUBCOMMAND ...ARGS', 'manage milestones'
    subcommand 'milestone', Milestone

    desc 'wiki SUBCOMMAND ...ARGS', 'manage wikis'
    subcommand 'wiki', Wiki

    desc 'project SUBCOMMAND ...ARGS', 'manage projects'
    subcommand 'project', Project

    desc 'recent SUBCOMMAND ...ARGS', 'list recent stuff'
    subcommand 'recent', Recent
  end
end
