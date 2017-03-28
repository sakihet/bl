module Bl
  class Users < Thor
    include Bl::Requestable

    def initialize(*)
      @config = Bl::Config.instance
      @url = 'users/'
      super
    end

    desc 'list', ''
    def list
      # TODO
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

    desc 'activities', ''
    def activities
      # TODO
    end

    desc 'stars', ''
    def stars
      # TODO
    end

    desc 'stars-count', ''
    def stars_count
      # TODO
    end
  end
end
