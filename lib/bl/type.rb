module Bl
  class Type < Thor
    include Bl::Requestable

    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/issueTypes"
      super
    end

    desc 'add NAMES', 'add types'
    option :color, type: :string, required: true
    def add(*names)
      names.each do |name|
        res = client.post(@url, name: name, color: options[:color])
        puts "type added: #{res.body.id}\t#{res.body.name}\t#{res.body.color}"
      end
    end

    desc 'update TYPE_IDS', 'update types'
    option :name, type: :string
    option :color, color: :color
    def update(*ids)
      ids.each do |id|
        res = client.patch("#{@url}/#{id}", options)
        puts "type updated: #{res.body.id}\t#{res.body.name}\t#{res.body.color}"
      end
    end

    desc 'delete TYPE_IDS', 'delete types'
    option :substituteIssueTypeId, type: :numeric, required: true
    def delete(*ids)
      ids.each do |id|
        res = client.delete("#{@url}/#{id}", options)
        puts "type deleted: #{res.body.id}\t#{res.body.name}\t#{res.body.color}"
      end
    end
  end
end
