module Bl
  class Category < Thor
    include Bl::Requestable

    def initialize(*)
      @config = Bl::Config.instance
      super
    end

    desc 'add NAME', 'add categories'
    def add(*names)
      names.each do |name|
        res = client.post("projects/#{@config[:project_key]}/categories", name: name)
        puts "category added: #{res.body.id}\t#{res.body.name}"
      end
    end

    desc 'update ID NEW_NAME', 'update a category'
    def update(id, name)
      res = client.patch("projects/#{@config[:project_key]}/categories/#{id}", name: name)
      puts "category updated: #{res.body.id}\t#{res.body.name}"
    end

    desc 'delete CATEGORY_ID', 'delete categories'
    def delete(*ids)
      ids.each do |id|
        res = client.delete("projects/#{@config[:project_key]}/categories/#{id}")
        puts "category deleted: #{res.body.id}\t#{res.body.name}"
      end
    end
  end
end
