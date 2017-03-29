module Bl
  class Users < Thor
    include Bl::Requestable

    def initialize(*)
      @config = Bl::Config.instance
      @url = 'users/'
      super
    end

    desc 'list', 'list users'
    def list
      client.get('users').body.each do |u|
        puts [u.id, u.userId, u.name, u.roleType, u.lang, u.mailAddress].join("\t")
      end
    end

    desc 'show', ''
    def show
      # TODO
    end

    desc 'add', ''
    def add
      # TODO
    end

    desc 'update', ''
    def update
      # TODO
    end

    desc 'delete', ''
    def delete
      # TODO
    end

    desc 'myself', ''
    def myself
      # TODO
    end

    desc 'icon', ''
    def icon
      # TODO
    end

    desc 'activities USER_ID', "list user's activities"
    options activityTypeId: :array, minId: :numeric, maxId: :numeric, count: :numeric, order: :string
    def activities(user_id)
      client.get("/users/#{user_id}/activities").body.each do |a|
        print_activity(a)
      end
    end

    desc 'stars', ''
    def stars
      # TODO
    end

    desc 'stars-count [USER_ID...]', "count user's stars"
    options since: :string, until: :string
    def stars_count
      user_ids.each do |user_id|
        p client.get("/users/#{user_id}/stars/count", options.to_h).body.count
      end
    end
  end
end
