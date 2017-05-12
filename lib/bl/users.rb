module Bl
  class Users < Command

    def initialize(*)
      @config = Bl::Config.instance
      @url = 'users'
      super
    end

    desc 'list', 'list users'
    def list
      res = request(:get, 'users')
      print_response(res)
    end

    desc 'show USER_ID', ''
    def show(id)
      res = request(:get, "#{@url}/#{id}")
      puts formatter.render(res.body, fields: USER_FIELDS)
    end

    desc 'add USER_ID PASSWORD NAME MAIL_ADDRESS ROLE_TYPE', ''
    def add(id, pass, name, mail_address, role_type)
      res = request(:post, "#{@url}", userId: id, password: pass, name: name, mailAddress: mail_address, roleType: role_type)
      puts 'user added'
      print_response(res)
    end

    desc 'update USER_ID', ''
    options USER_PARAMS
    def update(id)
      res = request(:patch, "#{@url}/#{id}", delete_class_options(options.to_h))
      puts 'user updated:'
      print_response(res)
    end

    desc 'delete', ''
    def delete(id)
      res = client.delete("#{@url}/#{id}")
      puts 'user deleted'
      print_response(res)
    end

    desc 'myself', ''
    def myself
      res = request(:get, "#{@url}/myself")
      print_response(res)
    end

    desc 'icon ID', ''
    def icon(id)
      # res = request(:get, "#{@url}/#{id}/icon")
      # TODO fix nil error
    end

    desc 'activities USER_ID', "list user's activities"
    options activityTypeId: :array, minId: :numeric, maxId: :numeric, count: :numeric, order: :string
    def activities(user_id)
      res = request(:get, "/users/#{user_id}/activities")
      res.body.map { |a| print_activity(a) }
    end

    desc 'stars [USER_ID...]', ''
    options minId: :numeric, maxId: :numeric, count: :numeric, order: :string
    def stars(*user_ids)
      user_ids.each do |user_id|
        res = request(:get, "/users/#{user_id}/stars", options.to_h)
        res.body.map { |s| p s }
      end
    end

    desc 'stars-count [USER_ID...]', "count user's stars"
    options since: :string, until: :string
    def stars_count(*user_ids)
      user_ids.each do |user_id|
        p request(:get, "/users/#{user_id}/stars/count", options.to_h).body.count
      end
    end

    private

    def print_response(res)
      puts formatter.render(res.body, fields: USER_FIELDS)
    end
  end
end
