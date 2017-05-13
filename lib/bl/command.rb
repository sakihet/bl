module Bl
  class Command < Thor
    include Bl::Requestable
    include Bl::Formatting
    include Bl::Printer
    class_option :format, type: :string, default: 'table', desc: 'set output format'

    protected

    def delete_class_options(h)
      opts = ['format']
      opts.map { |opt| h.delete(opt) }
      h
    end

    def format_datetime(str)
      DateTime.parse(str).strftime('%Y-%m-%d %H:%M') if str
    end

    def format_date(str)
      Date.parse(str).strftime('%Y-%m-%d') if  str
    end
  end
end
