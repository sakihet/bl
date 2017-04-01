module Bl
  class Notifications < Thor
    include Bl::Requestable

    def initialize(*)
      @config = Bl::Config.instance
      @url = 'notifications'
      super
    end

    desc 'list', ''
    options minId: :numeric, maxId: :numeric, count: :numeric, order: :string
    def list
      res = client.get(@url, options.to_h)
      res.body.map { |n| puts n.pretty_inspect }
    end

    desc 'count', ''
    options alreadyRead: :boolean, resourceAlreadyRead: :boolean
    def count
      # puts client.get("#{@url}/count").body.count
      # TODO fix nil error
    end

    desc 'mark-as-read', ''
    def mark_as_read
      res = client.post("#{@url}/markAsRead")
      puts 'notifications mark as readed'
      puts res.body.count
    end

    desc 'read NOTIFICATIONS_ID', ''
    def read(id)
      res = client.post("#{@url}/#{id}/markAsRead")
      puts "notifications #{id} readed"
      puts res.pretty_inspect
    end
  end
end
