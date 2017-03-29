module Bl
  class Notifications < Thor
    include Bl::Requestable

    def initialize(*)
      @config = Bl::Config.instance
      @url = ''
      super
    end

    desc 'list', ''
    def list
      # TODO
    end

    desc 'count', ''
    def count
      # TODO
    end

    desc 'mark-as-read', ''
    def mark_as_read
      # TODO
    end
  end
end
