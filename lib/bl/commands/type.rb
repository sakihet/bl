module Bl
  module Commands
    class Type < Command
      def initialize(*)
        @config = Bl::Config.instance
        @url = "projects/#{@config[:project_key]}/issueTypes"
        super
      end

      desc 'list', 'list issue types'
      def list
        res = request(:get, @url)
        puts 'types:'
        print_response(res, :type)
      end

      desc 'add [NAME...]', 'add types'
      option :color, type: :string, required: true
      def add(*names)
        names.each do |name|
          res = request(:post, @url, name: name, color: options[:color])
          puts 'type added'
          print_response(res, :type)
        end
      end

      desc 'update [ID...]', 'update types'
      option :name, type: :string
      option :color, color: :color
      def update(*ids)
        ids.each do |id|
          res = request(:patch, "#{@url}/#{id}", delete_class_options(options))
          puts 'type updated'
          print_response(res, :type)
        end
      end

      desc 'delete [ID...]', 'delete types'
      option :substituteIssueTypeId, type: :numeric, required: true
      def delete(*ids)
        ids.each do |id|
          res = request(:delete, "#{@url}/#{id}", delete_class_options(options))
          puts 'type deleted'
          print_response(res, :type)
        end
      end

      desc 'colors', 'list available colors'
      def colors
        puts 'colors:'
        TYPE_COLORS.each do |color|
          puts Paint[color, '#ffffff', color]
        end
      end
    end
  end
end
