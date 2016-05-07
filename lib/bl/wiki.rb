module Bl
  class Wiki < Thor
    include Bl::Requestable

    def initialize(*)
      @config = Bl::Config.instance
      @url = 'wikis'
      super
    end

    desc 'list', 'list wikis'
    def list
      client.get(@url, projectIdOrKey: @config[:project_key]).body.each do |w|
        puts [w.id, w.projectId, w.name, w.updated].join("\t")
      end
    end

    desc 'show ID', "show a wiki's content"
    def show(id)
      body = client.get("#{@url}/#{id}").body
      puts "id: #{body.id}"
      puts "projectId: #{body.projectId}"
      puts "name: #{body.name}"
      puts "updated: #{body.updated}"
      puts '--'
      puts 'content:'
      puts body.content
    end
  end
end
