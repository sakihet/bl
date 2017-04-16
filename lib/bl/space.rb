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
      puts client.get('space/notification').body.content
    end

    desc 'update-notification CONTENT', 'update space notification'
    def update_notification(content)
      client.put('space/notification', content: content)
    end

    desc 'disk-usage', 'get space disk usage'
    def disk_usage
      capacity = client.get('space/diskUsage').body.capacity
      puts "capacity: #{capacity}"
    end
  end
end
