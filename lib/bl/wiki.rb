module Bl
  class Wiki < Command
    def initialize(*)
      @config = Bl::Config.instance
      @url = 'wikis'
      super
    end

    desc 'add NAME', 'add wiki'
    option :projectId, type: :numeric, required: true
    option :content, type: :string, required: true
    def add(name)
      res = request(
        :post,
        @url,
        projectId: options[:projectId],
        name: name,
        content: options[:content]
        )
      puts 'wiki added:'
      print_response(res, :wiki)
    end

    desc 'count', 'count wiki'
    option :projectIdOrKey, type: :numeric, required: true
    def count
      res = request(:get, "#{@url}/count", projectIdOrKey: options[:projectIdOrKey])
      puts 'wiki count'
      puts res.body.count
    end

    desc 'delete ID', 'delete wiki'
    def delete(id)
      res = request(:delete, "#{@url}/#{id}")
      puts 'wiki deleted'
      print_response(res, :wiki)
    end

    desc 'list', 'list wikis'
    def list
      res = request(:get, @url, projectIdOrKey: @config[:project_key])
      print_response(res, :wiki)
    end

    desc 'show ID', "show a wiki's content"
    def show(id)
      res = request(:get, "#{@url}/#{id}")
      puts formatter.render(res.body, fields: WIKI_FIELDS.push(:content), vertical: true)
    end

    desc 'tags', 'show wiki tags'
    option :projectIdOrKey, type: :numeric, required: true
    def tags
      res = request(:get, "#{@url}/tags", projectIdOrKey: options[:projectIdOrKey])
      puts 'wiki tags:'
      print_response(res, :named)
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
