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

    def default_config
      {
        space_id: '',
        api_key: '',
        project_key: '',
        issue: {
          default_project_id: '',
          default_issue_type_id: '',
          default_priority_id: ''
        }
      }
    end
  end
end
