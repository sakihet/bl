module Bl
  class Watchings < Command

    def initialize(*)
      @config = Bl::Config.instance
      @url = 'watchings'
      super
    end

    desc 'list USER_ID', ''
    options WATCHINGS_PARAMS
    def list(id)
      res = request(:get, "/users/#{id}/#{@url}", delete_class_options(options.to_h))
      res.body.map { |t| print_watch_target(t) }
    end

    desc 'count USER_ID', ''
    options resourceAlreadyRead: :boolean, alreadyRead: :boolean
    def count(id)
      res = request(:get, "/users/#{id}/#{@url}/count")
      puts res.body.count
    end

    desc 'show WATCHING_ID', ''
    def show(id)
      res = request(:get, "watchings/#{id}")
      print_watch_target(res.body)
    end

    desc 'add', ''
    options issueIdOrKey: :required, note: :string
    def add
      res = request(:post, 'watchings', options.to_h)
      puts 'watch added'
      print_watch_target(res.body)
    end

    desc 'update WATCHING_ID', ''
    option note: :string
    def update(id)
      # TODO fix conflict with issue update command
      # res = request(:patch, "watchings/#{id}", option.to_h)
      # puts 'watch updated'
      # print_watch_target(res.body)
    end

    desc 'delete WATCHING_ID', ''
    def delete(id)
      res = client.delete("watchings/#{id}")
      puts 'watch deleted'
      print_watch_target(res.body)
    end

    desc 'mark-as-read WATCHING_ID', ''
    def mark_as_read(id)
      res = request(:post, "watchings/#{id}/markAsRead")
      puts 'watch mark as read'
    end

    desc 'mark-as-checked USER_ID', ''
    def mark_as_checked(id)
      res = request(:post, "/users/#{id}/watchings/markAsChecked")
      puts 'watch mark as checked'
    end

  end
end
