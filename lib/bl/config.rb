require 'singleton'
require 'yaml'

module Bl
  CONFIG_FILE = '.bl.yml'.freeze

  class Config
    include Singleton

    def initialize
      file = File.join(Dir.home, Bl::CONFIG_FILE)
      if File.exist?(file)
        @config = YAML.load_file(file)
      else
        @config = nil
      end
    end

    def [](key)
      @config[key]
    end
  end
end
