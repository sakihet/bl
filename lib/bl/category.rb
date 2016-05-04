module Bl
  class Category < Thor
    def initialize(*)
      @config = YAML.load_file(File.join(Dir.home, Bl::CONFIG_FILE))
      @client = BacklogKit::Client.new(
        space_id: @config[:space_id],
        api_key: @config[:api_key]
      )
      super
    end

    desc 'add NAME', 'add categories'
    def add(*names)
      names.each do |name|
        res = @client.post("projects/#{@config[:project_key]}/categories", name: name)
        puts "category added: #{res.body.id}\t#{res.body.name}"
      end
    end

    desc 'delete CATEGORY_ID', 'delete categories'
    def delete(*ids)
      ids.each do |id|
        res = @client.delete("projects/#{@config[:project_key]}/categories/#{id}")
        puts "category deleted: #{res.body.id}\t#{res.body.name}"
      end
    end
  end
end
