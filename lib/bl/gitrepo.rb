module Bl
  class GitRepo < Thor
    include Bl::Requestable

    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/git/repositories"
      super
    end

    desc 'list', 'list git repositories'
    def list
      client.get(@url).body.each do |repo|
        puts [
          repo.id,
          repo.projectId,
          repo.name,
          repo.description,
          repo.sshUrl
        ].join("\t")
      end
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
