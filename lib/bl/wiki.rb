module Bl
  class Wiki < Command

    def initialize(*)
      @config = Bl::Config.instance
      @url = 'wikis'
      super
    end

    desc 'list', 'list wikis'
    def list
      res = request(:get, @url, projectIdOrKey: @config[:project_key])
      puts formatter.render(res.body, fields: WIKI_FIELDS)
    end

    desc 'show ID', "show a wiki's content"
    def show(id)
      body = request(:get, "#{@url}/#{id}").body
      puts "id: #{body.id}"
      puts "projectId: #{body.projectId}"
      puts "name: #{body.name}"
      puts "updated: #{body.updated}"
      puts '--'
      puts 'content:'
      puts body.content
    end

    desc 'edit ID', 'edit a wiki by $EDITOR'
    def edit(id)
      wiki_content = request(:get, "#{@url}/#{id}").body.content
      file = Tempfile.new
      file.puts(wiki_content)
      file.close
      begin
        file.open
        system("$EDITOR #{file.path}")
        new_content = file.read
        request(:patch, "#{@url}/#{id}", content: new_content)
        puts "wiki #{id} updated."
      ensure
        file.close
        file.unlink
      end
    end
  end
end
