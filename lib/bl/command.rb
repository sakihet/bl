module Bl
  class Command < Thor
    include Bl::Requestable
    include Bl::Formatting
    class_option :format, type: :string, default: 'table', desc: 'set output format'

    protected

    def delete_class_options(h)
      opts = ['format']
      opts.map { |opt| h.delete(opt) }
      h
    end
  end
end
