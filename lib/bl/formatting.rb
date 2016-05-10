module Bl
  module Formatting extend self

    def colorize_type(name, color)
      Paint[name, :white, color]
    end
  end
end
