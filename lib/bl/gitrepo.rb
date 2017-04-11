module Bl
  class GitRepo < Command

    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/git/repositories"
      super
    end

    desc 'list', 'list git repositories'
    def list
      res = client.get(@url)
      puts formatter.render(res.body, fields: %i(id projectId name description sshUrl))
    end

    desc 'show ID', 'show a git repository'
    def show(id)
      body = client.get("#{@url}/#{id}").body
      puts "id: #{body.id}"
      puts "projectId: #{body.projectId}"
      puts "name: #{body.name}"
      puts "description: #{body.description}"
      puts "hookUrl: #{body.hookUrl}"
      puts "httpUrl: #{body.httpUrl}"
      puts "sshUrl: #{body.sshUrl}"
      puts "displayOrder: #{body.displayOrder}"
      puts "pushedAt: #{body.pushedAt}"
      puts "createdUser: #{body.createdUser.name}"
      puts "created: #{body.created}"
      puts "updatedUser: #{body.updatedUser.name}"
      puts "updated: #{body.updated}"
    end
  end
end
