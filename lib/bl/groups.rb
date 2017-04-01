module Bl
  class Groups < Thor
    include Bl::Requestable
    include Bl::Formatting

    def initialize(*)
      @config = Bl::Config.instance
      @url = 'groups'
      super
    end

    desc 'list', ''
    options order: :string, offset: :numeric, count: :numeric
    def list
      res = client.get(@url, options.to_h)
      res.body.map { |g| print_group(g) }
    end

    desc 'show GROUP_ID', ''
    def show(id)
      res = client.get("#{@url}/#{id}")
      print_group_and_members(res.body)
    end

    desc 'add GROUP_NAME', ''
    options members: :array
    def add(name)
      res = client.post(@url, {name: name}.merge(options))
      puts 'group added'
      print_group_and_members(res.body)
    end

    desc 'update GROUP_ID', ''
    options name: :string, members: :array
    def update(id)
      res = client.patch("#{@url}/#{id}", options.to_h)
      puts 'group updated'
      print_group_and_members(res.body)
    end

    desc 'delete GROUP_ID', ''
    def delete(id)
      res = client.delete("#{@url}/#{id}")
      puts 'group deleted'
      print_group_and_members(res.body)
    end
  end
end
