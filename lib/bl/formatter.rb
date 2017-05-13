require 'hirb'
require 'hirb-unicode'
require 'json'

module Bl
  class Formatter
    TPUT_COLS = `tput cols`.to_i

    def initialize(format: 'table')
      @format = case format
      when 'table'
        Format::Hirb
      when 'json'
        Format::Json
      else
        abort 'format must be set to \'table\' or \'json\''
      end
    end

    def render(*args)
      @format.render(args[0], args[1].merge(max_width: TPUT_COLS))
    end

    module Format
      class Hirb < Hirb::Helpers::AutoTable
      end

      class Json
        def self.render(objects, fields: [])
          result = []
          objects.each do |obj|
            h = {}
            fields.map { |f| h.store(f, obj.send(f)) }
            result << h
          end
          result.to_json
        end
      end
    end
  end
end
