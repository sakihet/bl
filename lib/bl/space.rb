module Bl
  class Space < Thor
    include Bl::Requestable
    include Bl::Formatting

    def initialize(*)
      @config = Bl::Config.instance
      super
    end

    desc 'info', 'show space info'
    def info
    end

    desc 'activities', 'show space activities'
    def activities
    end

    desc 'image', ''
    def image
    end

    desc 'get-notification', ''
    def get_notification
    end

    desc 'update-notification', ''
    def update_notification
    end

    desc 'disk-usage', ''
    def disk_usage
    end
  end
end
