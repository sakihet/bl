module Bl
  class Command < Thor
    include Bl::Requestable
    include Bl::Formatting
    class_option :format, type: :string, default: 'table', desc: 'set output format'
  end
end
