module Bl
  class Type < Command

    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/issueTypes"
      super
    end

    desc 'list', 'list issue types'
    def list
      res = client.get(@url)
      print_response(res)
    end

    desc 'add [NAME...]', 'add types'
    option :color, type: :string, required: true
    def add(*names)
      names.each do |name|
        res = client.post(@url, name: name, color: options[:color])
        puts 'type added'
        print_response(res)
      end
    end

    desc 'update [ID...]', 'update types'
    option :name, type: :string
    option :color, color: :color
    def update(*ids)
      ids.each do |id|
        res = client.patch("#{@url}/#{id}", options)
        puts 'type updated'
        print_response(res)
      end
    end

    desc 'delete [ID...]', 'delete types'
    option :substituteIssueTypeId, type: :numeric, required: true
    def delete(*ids)
      ids.each do |id|
        res = client.delete("#{@url}/#{id}", options)
        puts 'type deleted'
        print_response
      end
    end

    desc 'colors', 'list colors'
    def colors
      TYPE_COLORS.each do |color|
        puts Paint[color, '#ffffff', color]
      end
    end

    private

    def print_response(res)
      puts formatter.render(res.body, fields: %i(id name color))
    end
  end
end
