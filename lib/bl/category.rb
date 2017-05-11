module Bl
  class Category < Command

    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/categories"
      super
    end

    desc 'list', 'list categories'
    def list
      res = request(:get, @url)
      print_response(res)
    end

    desc 'add [NAME...]', 'add categories'
    def add(*names)
      names.each do |name|
        res = client.post(@url, name: name)
        puts 'category added'
        print_response(res)
      end
    end

    desc 'update [ID...]', 'update categories'
    option :name, type: :string
    def update(*ids)
      ids.each do |id|
        res = client.patch("#{@url}/#{id}", delete_class_options(options))
        puts 'category updated'
        print_response(res)
      end
    end

    desc 'delete [ID...]', 'delete categories'
    def delete(*ids)
      ids.each do |id|
        res = client.delete("#{@url}/#{id}")
        puts 'category deleted'
        print_response(res)
      end
    end

    private

    def print_response(res)
      puts formatter.render(res.body, fields: CATEGORY_FIELDS)
    end
  end
end
