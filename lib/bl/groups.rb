module Bl
  class Groups < Command

    def initialize(*)
      @config = Bl::Config.instance
      @url = 'groups'
      super
    end

    desc 'list', ''
    options order: :string, offset: :numeric, count: :numeric
    def list
      res = client.get(@url, options.to_h)
      puts formatter.render(res.body, fields: %i(id name))
    end

    desc 'show GROUP_ID', ''
    def show(id)
      res = client.get("#{@url}/#{id}")
      puts formatter.render(res.body.members, fields: USER_FIELDS)
    end

    desc 'add GROUP_NAME', ''
    options members: :array
    def add(name)
      res = client.post(@url, {name: name}.merge(delete_class_options(options)))
      puts 'group added'
      print_group_and_members(res.body)
    end

    desc 'update GROUP_ID', ''
    options name: :string, members: :array
    def update(id)
      res = client.patch("#{@url}/#{id}", delete_class_options(options.to_h))
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
