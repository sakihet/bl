module Bl
  module Commands
    class Category < Command
      def initialize(*)
        @config = Bl::Config.instance
        @url = "projects/#{@config[:project_key]}/categories"
        super
      end

      desc 'list', 'list categories'
      def list
        res = request(:get, @url)
        puts 'categories:'
        print_response(res, :category)
      end

      desc 'add [NAME...]', 'add categories'
      def add(*names)
        names.each do |name|
          res = request(:post, @url, name: name)
          puts 'category added'
          print_response(res, :category)
        end
      end

      desc 'update [ID...]', 'update categories'
      option :name, type: :string
      def update(*ids)
        ids.each do |id|
          res = request(:patch, "#{@url}/#{id}", delete_class_options(options))
          puts 'category updated'
          print_response(res, :category)
        end
      end

      desc 'delete [ID...]', 'delete categories'
      def delete(*ids)
        ids.each do |id|
          res = request(:delete, "#{@url}/#{id}")
          puts 'category deleted'
          print_response(res, :category)
        end
      end
    end
  end
end
