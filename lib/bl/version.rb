module Bl
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 0
    MINOR = 6
    TINY = 4

    STRING = [MAJOR, MINOR, TINY].join('.')
  end
end
