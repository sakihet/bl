module Bl
  class Users < Thor
    include Bl::Requestable
    include Bl::Formatting

    def initialize(*)
      @config = Bl::Config.instance
      @url = 'users'
      super
    end

    desc 'list', 'list users'
    def list
      client.get('users').body.map { |u| print_user(u) }
    end

    desc 'show USER_ID', ''
    def show(id)
      res = client.get("#{@url}/#{id}")
      print_user(res.body)
    end

    desc 'add USER_ID PASSWORD NAME MAIL_ADDRESS ROLE_TYPE', ''
    def add(id, pass, name, mail_address, role_type)
      res = client.post("#{@url}", userId: id, password: pass, name: name, mailAddress: mail_address, roleType: role_type)
      print_user(res.body)
    end

    USER_PARAMS = {
      password: :string,
      name: :string,
      mailAddress: :string,
      roleType: :numeric
    }
    desc 'update USER_ID', ''
    options USER_PARAMS
    def update(id)
      res = client.patch("#{@url}/#{id}", options.to_h)
      puts 'user updated:'
      print_user(res.body)
    end

    desc 'delete', ''
    def delete(id)
      res = client.delete("#{@url}/#{id}")
      puts 'user deleted'
      print_user(res.body)
    end

    desc 'myself', ''
    def myself
      res = client.get("#{@url}/myself")
      print_user(res.body)
    end

    desc 'icon ID', ''
    def icon(id)
      # res = client.get("#{@url}/#{id}/icon")
      # TODO fix nil error
    end

    desc 'activities USER_ID', "list user's activities"
    options activityTypeId: :array, minId: :numeric, maxId: :numeric, count: :numeric, order: :string
    def activities(user_id)
      res = client.get("/users/#{user_id}/activities")
      res.body.map { |a| print_activity(a) }
    end

    desc 'stars [USER_ID...]', ''
    options minId: :numeric, maxId: :numeric, count: :numeric, order: :string
    def stars(*user_ids)
      user_ids.each do |user_id|
        res = client.get("/users/#{user_id}/stars", options.to_h)
        res.body.map { |s| p s }
      end
    end

    desc 'stars-count [USER_ID...]', "count user's stars"
    options since: :string, until: :string
    def stars_count(*user_ids)
      user_ids.each do |user_id|
        p client.get("/users/#{user_id}/stars/count", options.to_h).body.count
      end
    end
  end
end
