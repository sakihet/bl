module Bl
  class Webhooks < Command

    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/webhooks"
      super
    end

    desc 'list', ''
    def list
      res = request(:get, @url)
      print_response(res)
    end

    desc 'show WEBHOOK_ID', ''
    def show(id)
      res = request(:get, "#{@url}/#{id}")
      print_response(res)
    end

    desc 'add', ''
    options WEBHOOK_PARAMS
    def add
      res = client.post(@url, options.to_h)
      puts 'webhook added'
      print_response(res)
    end

    desc 'update WEBHOOK_ID', ''
    options WEBHOOK_PARAMS
    def update(id)
      res = client.patch("#{@url}/#{id}", options.to_h)
      puts 'webhook updated'
      print_response(res)
    end

    desc 'delete WEBHOOK_ID', ''
    def delete(id)
      res = client.delete("#{@url}/#{id}")
      puts 'webhook deleted'
      print_response(res)
    end

    private

    def print_response(res)
      puts formatter.render(res.body, fields: WEBHOOK_FIELDS)
    end
  end
end
