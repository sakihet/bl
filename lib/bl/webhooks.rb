module Bl
  class Webhooks < Thor
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
  end
end
