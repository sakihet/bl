module Bl
  module Requestable
    module_function

    def client
      BacklogKit::Client.new(
        space_id: @config[:space_id],
        api_key: @config[:api_key]
      )
    end
  end
end
