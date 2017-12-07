module Bl
  class CLI < Command
    def initialize(*)
      @config = Bl::Config.instance
      super
    end

    desc 'version', 'show version'
    def version
      puts Bl.gem_version
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

    desc 'show KEY', "show an issue's details"
    def show(key)
      res  = request(:get, "issues/#{key}")
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
      puts 'attachments:'
      body[0].attachments.each do |file|
        puts ['-', file.id, file.name, file.size].join("\t")
        puts "\tview url: https://#{@config[:space_id]}.backlog.jp/ViewAttachment.action?attachmentId=#{file.id}"
        puts "\tdownload url: https://#{@config[:space_id]}.backlog.jp/downloadAttachment/#{file.id}/#{file.name}"
      end
      puts 'shared files:'
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

    desc 'statuses', 'list statuses'
    def statuses
      res = request(:get, 'statuses')
      print_response(res, :named)
    end

    desc 'priorities', 'list priorities'
    def priorities
      res = request(:get, 'priorities')
      print_response(res, :named)
    end

    desc 'resolutions', 'list resolutions'
    def resolutions
      res = request(:get, 'resolutions')
      print_response(res, :named)
    end

    desc 'roles', 'list roles'
    def roles
      puts formatter.render(ROLES, fields: %i(id name))
    end

    desc 'category SUBCOMMAND ...ARGS', 'manage categories'
    subcommand 'category', Commands::Category

    desc 'file SUBCOMMAND ...ARGS', 'manage files'
    subcommand 'file', Commands::File

    desc 'gitrepo SUBCOMMAND ...ARGS', 'show gitrepos'
    subcommand 'gitrepo', Commands::GitRepo

    desc 'group SUBCOMMAND ...ARGS', 'manage groups'
    subcommand 'group', Commands::Group

    desc 'issue SUBCOMMAND ...ARGS', 'manage issues'
    subcommand 'issue', Commands::Issue

    desc 'milestone SUBCOMMAND ...ARGS', 'manage milestones'
    subcommand 'milestone', Commands::Milestone

    # desc 'notification SUBCOMMAND ...ARGS', 'manage notifications'
    # subcommand 'notification', Commands::Notification

    desc 'project SUBCOMMAND ...ARGS', 'manage projects'
    subcommand 'project', Commands::Project

    desc 'pullrequest SUBCOMMAND ...ARGS', 'manage pull requests'
    subcommand 'pullrequest', Commands::PullRequest

    desc 'recent SUBCOMMAND ...ARGS', 'list recent stuff'
    subcommand 'recent', Commands::Recent

    desc 'space SUBCOMMAND ...ARGS', 'manage space'
    subcommand 'space', Commands::Space

    desc 'type SUBCOMMAND ...ARGS', 'manage types'
    subcommand 'type', Commands::Type

    desc 'user SUBCOMMAND ...ARGS', 'manage users'
    subcommand 'user', Commands::User

    desc 'watching SUBCOMMAND ...ARGS', 'manage watchings'
    subcommand 'watching', Commands::Watching

    desc 'webhook SUBCOMMAND ...ARGS', 'manage webhooks'
    subcommand 'webhook', Commands::Webhook

    desc 'wiki SUBCOMMAND ...ARGS', 'manage wikis'
    subcommand 'wiki', Commands::Wiki
  end
end
