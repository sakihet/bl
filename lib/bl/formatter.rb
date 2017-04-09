require 'hirb'
require 'hirb-unicode'

module Bl
  class Formatter
    def initialize(format: 'table')
      @format = case format
      when 'table'
        Format::Hirb
      else
        abort ''
      end
    end

    def render(*args)
      @format.render(*args)
    end

    module Format
      class Hirb < Hirb::Helpers::AutoTable
      end
    end
  end
end
