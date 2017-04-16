module Bl
  class Type < Command

    TYPE_COLORS = %w(
      #e30000
      #934981
      #814fbc
      #007e9a
      #ff3265
      #666665
      #990000
      #2779ca
      #7ea800
      #ff9200
    )

    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/issueTypes"
      super
    end

    desc 'list', 'list issue types'
    def list
      res = client.get(@url)
      puts formatter.render(res.body, fields: %i(id name color))
    end

    desc 'add [NAME...]', 'add types'
    option :color, type: :string, required: true
    def add(*names)
      names.each do |name|
        res = client.post(@url, name: name, color: options[:color])
        puts "type added: #{res.body.id}\t#{res.body.name}\t#{res.body.color}"
      end
    end

    desc 'update [ID...]', 'update types'
    option :name, type: :string
    option :color, color: :color
    def update(*ids)
      ids.each do |id|
        res = client.patch("#{@url}/#{id}", options)
        puts "type updated: #{res.body.id}\t#{res.body.name}\t#{res.body.color}"
      end
    end

    desc 'delete [ID...]', 'delete types'
    option :substituteIssueTypeId, type: :numeric, required: true
    def delete(*ids)
      ids.each do |id|
        res = client.delete("#{@url}/#{id}", options)
        puts "type deleted: #{res.body.id}\t#{res.body.name}\t#{res.body.color}"
      end
    end

    desc 'colors', 'list colors'
    def colors
      TYPE_COLORS.each do |color|
        puts Paint[color, '#ffffff', color]
      end
    end
  end
end
