module Bl
  class Watchings < Thor
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

    desc 'mark-as-read', ''
    def mark_as_read
      # TODO
    end

    desc 'mark-as-checked', ''
    def mark_as_checked
      # TODO
    end
  end
end
