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
        puts 'please input space name: '
        space_id = STDIN.gets.chomp
        puts 'plese input api key: '
        api_key = STDIN.gets.chomp
        config[:space_id] = space_id.to_s
        config[:api_key] = api_key.to_s
        client = BacklogKit::Client.new(
          space_id: space_id,
          api_key: api_key
        )
        res = client.get('projects')
        project_key = res.body[0].projectKey
        config[:project_key] = project_key
        config[:issue][:default][:projectId] = res.body[0].id
        res = client.get("projects/#{project_key}/issueTypes")
        config[:issue][:default][:issueTypeId] = res.body[0].id
        res = client.get('priorities')
        config[:issue][:default][:priorityId] = res.body[1].id
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
      print_issue_response(printable_issues(res.body))
    end

    desc 'search', 'search issues'
    options ISSUES_PARAMS
    def search
      res = client.get('issues', delete_class_options(options.to_h))
      print_issue_response(printable_issues(res.body))
    end

    desc 'show KEY', "show an issue's details"
    def show(key)
      res  = client.get("issues/#{key}")
      body = printable_issues(res.body)
      additional_fileds = %w(
        description
        category
        resolution
        versions
        milestone
        createdUser
      )
      fields = ISSUE_FIELDS.concat(additional_fileds)
      puts formatter.render(body, fields: fields, vertical: true)

      puts '--'
      puts "attachments:"
      body[0].attachments.each do |file|
        puts ['-', file.id, file.name, file.size].join("\t")
        puts "\tview url: https://#{@config[:space_id]}.backlog.jp/ViewAttachment.action?attachmentId=#{file.id}"
        puts "\tdownload url: https://#{@config[:space_id]}.backlog.jp/downloadAttachment/#{file.id}/#{file.name}"
      end
      puts "shared files:"
      body[0].sharedFiles.each do |file|
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
        puts '💡 issue added'
        print_issue_response(printable_issues(res.body))
      end
    end

    desc 'update [KEY...]', 'update issues'
    options ISSUE_BASE_ATTRIBUTES
    option :comment, type: :string
    def update(*keys)
      keys.each do |k|
        res = client.patch("issues/#{k}", delete_class_options(options.to_h))
        puts 'issue updated'
        print_issue_response(printable_issues(res.body))
      end
    end

    desc 'close [KEY...]', 'close issues'
    def close(*keys)
      keys.each do |k|
        res = client.patch("issues/#{k}", statusId: 4)
        puts '🎉 issue closed'
        print_issue_response(printable_issues(res.body))
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

    desc 'category SUBCOMMAND ...ARGS', 'manage categories'
    subcommand 'category', Category

    desc 'file SUBCOMMAND ...ARGS', 'manage files'
    subcommand 'file', File

    desc 'gitrepo SUBCOMMAND ...ARGS', 'show gitrepos'
    subcommand 'gitrepo', GitRepo

    desc 'groups SUBCOMMAND ...ARGS', 'manage groups'
    subcommand 'groups', Groups

    desc 'milestone SUBCOMMAND ...ARGS', 'manage milestones'
    subcommand 'milestone', Milestone

    desc 'notifications SUBCOMMAND ...ARGS', 'manage notifications'
    subcommand 'notifications', Notifications

    desc 'project SUBCOMMAND ...ARGS', 'manage projects'
    subcommand 'project', Project

    desc 'recent SUBCOMMAND ...ARGS', 'list recent stuff'
    subcommand 'recent', Recent

    desc 'space SUBCOMMAND ...ARGS', 'manage space'
    subcommand 'space', Space

    desc 'type SUBCOMMAND ...ARGS', 'manage types'
    subcommand 'type', Type

    desc 'users SUBCOMMAND ...ARGS', 'manage users'
    subcommand 'users', Users

    desc 'watchings SUBCOMMAND ...ARGS', 'manage watchings'
    subcommand 'watchings', Watchings

    desc 'webhooks SUBCOMMAND ...ARGS', 'manage webhooks'
    subcommand 'webhooks', Webhooks

    desc 'wiki SUBCOMMAND ...ARGS', 'manage wikis'
    subcommand 'wiki', Wiki

    private

    def print_issue_response(res)
      puts formatter.render(res, fields: ISSUE_FIELDS)
    end

    def printable_issues(ary)
      ary = Array(ary)
      ary.each do |v|
        v.issueType = v.issueType.name
        v.assignee = v.assignee.name if v.assignee
        v.status = v.status.name
        v.priority = v.priority.name
        v.created = format_datetime(v.created)
        v.updated = format_datetime(v.updated)
      end
      ary
    end
  end
end
