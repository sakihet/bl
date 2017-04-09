module Bl
  class Category < Thor
    include Bl::Requestable
    class_option :format, type: :string, default: 'table', desc: 'set output format'

    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/categories"
      super
    end

    desc 'list', 'list categories'
    def list
      res = client.get(@url)
      puts formatter.render(res.body, fields: %i(id name))
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
