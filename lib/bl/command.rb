module Bl
  class Command < Thor
    include Bl::Requestable
    include Bl::Formatting
    class_option :format, type: :string, default: 'table', desc: 'set output format'

    TPUT_COLS = `tput cols`.to_i

    protected

    def delete_class_options(h)
      opts = ['format']
      opts.map { |opt| h.delete(opt) }
      h
    end
  end
end
