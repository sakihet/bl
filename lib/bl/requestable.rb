module Bl
  module Requestable
    module_function

    def client
      BacklogKit::Client.new(
        space_id: @config[:space_id],
        api_key: @config[:api_key],
        second_level_domain: @config[:second_level_domain],
        top_level_domain: @config[:top_level_domain]
      )
    end

    def formatter
      @formatter ||= Formatter.new(format: options[:format])
    end

    def request(method, url, opts = nil)
      case method
      when :get
        client.get(url, opts.to_h)
      when :post
        client.post(url, opts.to_h)
      when :patch
        client.patch(url, opts.to_h)
      when :delete
        client.delete(url, opts.to_h)
      else
        raise 'invalid method error'
      end
    rescue => e
      puts e.message
    end
  end
end
