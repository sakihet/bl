module Bl
  module Formatting extend self

    def colorize_type(name, color)
      Paint[name, :white, color]
    end

    def colorize_priority(id, name)
      case id
      when 2
        Paint[name, :black, '#ffcccc']
      when 3
        Paint[name, :black, '#ccccff']
      when 4
        Paint[name, :black, '#ccffcc']
      else
        raise 'error'
      end
    end

    def colorize_status(id, name)
      case id
      when 1
        Paint[name, :black, '#ffcccc']
      when 2
        Paint[name, :black, '#acd9d3']
      when 3
        Paint[name, :black, '#d3e0ef']
      when 4
        Paint[name, :black, '#c2d3a3']
      else
        raise 'error'
      end
    end

  end
end
