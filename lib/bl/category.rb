module Bl
  class Category < Thor
    include Bl::Requestable

    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/categories"
      super
    end

    desc 'list', 'list categories'
    def list
      client.get(@url).body.each do |c|
        puts [c.id, c.name].join("\t")
      end
    end

    desc 'add [NAME...]', 'add categories'
    def add(*names)
      names.each do |name|
        res = client.post(@url, name: name)
        puts "category added: #{res.body.id}\t#{res.body.name}"
      end
    end

    desc 'update [ID...]', 'update categories'
    option :name, type: :string
    def update(*ids)
      ids.each do |id|
        res = client.patch("#{@url}/#{id}", options)
        puts "category updated: #{res.body.id}\t#{res.body.name}"
      end
    end

    desc 'delete [ID...]', 'delete categories'
    def delete(*ids)
      ids.each do |id|
        res = client.delete("#{@url}/#{id}")
        puts "category deleted: #{res.body.id}\t#{res.body.name}"
      end
    end
  end
end
