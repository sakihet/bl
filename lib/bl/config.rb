require 'singleton'
require 'yaml'

module Bl
  CONFIG_FILE = '.bl.yml'

  class Config
    include Singleton

    def initialize
      @config = YAML.load_file(File.join(Dir.home, Bl::CONFIG_FILE))
    end

    def [](key)
      @config[key]
    end
  end
end
