module Bl
  module Commands
    class Group < Command
      def initialize(*)
        @config = Bl::Config.instance
        @url = 'groups'
        super
      end

      desc 'list', 'list groups'
      options order: :string, offset: :numeric, count: :numeric
      def list
        res = request(:get, @url, options.to_h)
        puts formatter.render(res.body, fields: %i(id name))
      end

      desc 'show GROUP_ID', 'show group'
      def show(id)
        res = request(:get, "#{@url}/#{id}")
        puts formatter.render(res.body.members, fields: USER_FIELDS)
      end

      desc 'add GROUP_NAME', 'add group'
      options members: :array
      def add(name)
        res = request(:post, @url, { name: name }.merge(delete_class_options(options)))
        puts 'group added'
        print_group_and_members(res.body)
      end

      desc 'update GROUP_ID', 'update group'
      options name: :string, members: :array
      def update(id)
        res = request(:patch, "#{@url}/#{id}", delete_class_options(options.to_h))
        puts 'group updated'
        print_group_and_members(res.body)
      end

      desc 'delete GROUP_ID', 'delete group'
      def delete(id)
        res = request(:delete, "#{@url}/#{id}")
        puts 'group deleted'
        print_group_and_members(res.body)
      end
    end
  end
end
