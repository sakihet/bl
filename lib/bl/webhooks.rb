module Bl
  class Webhooks < Command

    def initialize(*)
      @config = Bl::Config.instance
      @url = "projects/#{@config[:project_key]}/webhooks"
      super
    end

    desc 'list', ''
    def list
      res = client.get(@url)
      puts formatter.render(res.body, fields: %i(id name description hookUrl))
    end

    desc 'show WEBHOOK_ID', ''
    def show(id)
      res = client.get("#{@url}/#{id}")
      print_webhook(res.body)
    end

    desc 'add', ''
    options WEBHOOK_PARAMS
    def add
      res = client.post(@url, options.to_h)
      puts 'webhook added'
      print_webhook(res.body)
    end

    desc 'update WEBHOOK_ID', ''
    options WEBHOOK_PARAMS
    def update(id)
      res = client.patch("#{@url}/#{id}", options.to_h)
      puts 'webhook updated'
      print_webhook(res.body)
    end

    desc 'delete WEBHOOK_ID', ''
    def delete(id)
      res = client.delete("#{@url}/#{id}")
      puts 'webhook deleted'
      print_webhook(res.body)
    end
  end
end
