require "thor"
require "bl/version"

module Bl
  class CLI < Thor
    desc "version", "show version"
    def version
      puts Bl::VERSION
    end
  end
end

Bl::CLI.start(ARGV)
