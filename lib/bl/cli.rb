module Bl

  class CLI < Command

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
      filename = ::File.join(Dir.home, Bl::CONFIG_FILE)
      if ::File.exist?(filename)
        puts "#{filename} exits."
      else
        config = Bl::Config.instance.default_config
        f = ::File.new(filename, 'w')
        f.write(config.to_yaml)
        puts "#{filename} generated."
      end
    end

    desc 'count', 'count issues'
    options ISSUES_PARAMS
    def count
      puts client.get('issues/count', delete_class_options(options.to_h)).body.count
    end

    desc 'list', 'list issues by typical ways'
    option :all
    option :unassigned
    option :today
    option :overdue
    option :priority
    option :nocategory
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
      res = client.get('issues', opts)
      puts formatter.render(res.body, fields: ISSUE_FIELDS, max_width: TPUT_COLS)
    end

    desc 'search', 'search issues'
    options ISSUES_PARAMS
    def search
      res = client.get('issues', delete_class_options(options.to_h))
      puts formatter.render(res.body, fields: ISSUE_FIELDS, max_width: TPUT_COLS)
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
      puts "assignee: #{body.assignee&.name}"
      puts "created user: #{body.createdUser.name}"
      puts '--'
      puts "description:"
      puts body.description
      puts "attachments:"
      body.attachments.each do |file|
        puts ['-', file.id, file.name, file.size].join("\t")
        puts "\tview url: https://#{@config[:space_id]}.backlog.jp/ViewAttachment.action?attachmentId=#{file.id}"
        puts "\tdownload url: https://#{@config[:space_id]}.backlog.jp/downloadAttachment/#{file.id}/#{file.name}"
      end
      puts "shared files:"
      body.sharedFiles.each do |file|
        puts ['-', file.id, file.name, file.size].join("\t")
        puts "\tfile url: https://#{@config[:space_id]}.backlog.jp/ViewSharedFile.action?projectKey=#{@config[:project_key]}&sharedFileId=#{file.id}"
      end
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
          issue_default_options.merge({summary: s}).merge(delete_class_options(options.to_h))
        )
        puts "issue added: #{res.body.issueKey}\t#{res.body.summary}"
      end
    end

    desc 'update [KEY...]', 'update issues'
    options ISSUE_BASE_ATTRIBUTES
    option :comment, type: :string
    def update(*keys)
      keys.each do |k|
        res = client.patch("issues/#{k}", delete_class_options(options.to_h))
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

    desc 'edit KEY', "edit issues' description by $EDITOR"
    def edit(key)
      issue_description = client.get("issues/#{key}").body.description
      file = Tempfile.new
      file.puts(issue_description)
      file.close
      begin
        file.open
        system("$EDITOR #{file.path}")
        new_content = file.read
        client.patch("issues/#{key}", description: new_content)
        puts "issue #{key} updated."
      ensure
        file.close
        file.unlink
      end
    end

    desc 'statuses', 'list statuses'
    def statuses
      res = client.get('statuses')
      puts formatter.render(res.body, fields: %i(id name))
    end

    desc 'priorities', 'list priorities'
    def priorities
      res = client.get('priorities')
      puts formatter.render(res.body, fields: %i(id name))
    end

    desc 'resolutions', 'list resolutions'
    def resolutions
      res = client.get('resolutions')
      puts formatter.render(res.body, fields: %i(id name))
    end

    desc 'roles', 'list roles'
    def roles
      puts formatter.render(ROLES, fields: %i(id name))
    end

    desc 'doctor', 'check issues'
    def doctor
      unassigned_issues = client.get('issues', assigneeId: [-1]).body
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

    desc 'space SUBCOMMAND ...ARGS', ''
    subcommand 'space', Space

    desc 'users SUBCOMMAND ...ARGS', ''
    subcommand 'users', Users

    desc 'groups SUBCOMMAND ...ARGS', ''
    subcommand 'groups', Groups

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

    desc 'file SUBCOMMAND ...ARGS', 'manage files'
    subcommand 'file', File

    desc 'gitrepo SUBCOMMAND ...ARGS', 'show gitrepos'
    subcommand 'gitrepo', GitRepo

    desc 'webhooks SUBCOMMAND ...ARGS', ''
    subcommand 'webhooks', Webhooks

    desc 'notifications SUBCOMMAND ...ARGS', ''
    subcommand 'notifications', Notifications

    desc 'watchings SUBCOMMAND ...ARGS', ''
    subcommand 'watchings', Watchings

  end
end
