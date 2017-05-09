module Bl
  class Space < Command

    def initialize(*)
      @config = Bl::Config.instance
      super
    end

    desc 'info', 'show space info'
    def info
      res = client.get('space')
      puts formatter.render(res.body, fields: SPACE_FIELDS)
    end

    desc 'activities', 'show space activities'
    def activities
      client.get('space/activities').body.each do |a|
        p a.pretty_inspect
      end
    end

    desc 'image', 'get space image file'
    def image
      body = client.get('space/image').body
      ::File.open(body.filename, "wb") {|f| f.write(body.content)}
      puts "#{body.filename} generated."
    end

    desc 'get-notification', 'get space notification'
    def get_notification
      res = client.get('space/notification')
      print_space_notification(res)
    end

    desc 'update-notification CONTENT', 'update space notification'
    def update_notification(content)
      res = client.put('space/notification', content: content)
      puts 'space notification updated'
      print_space_notification(res)
    end

    desc 'disk-usage', 'get space disk usage'
    def disk_usage
      res = client.get('space/diskUsage')
      print_space_disk_usage(res)
    end

    private

    def print_space_notification(res)
      puts formatter.render(res.body, fields: SPACE_NOTIFICATION_FIELDS)
    end

    def print_space_disk_usage(res)
      puts formatter.render(res.body, fields: SPACE_DISK_USAGE)
    end
  end
end
