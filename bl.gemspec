# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bl/version'

Gem::Specification.new do |spec|
  spec.name          = 'bl'
  spec.version       = Bl::VERSION
  spec.authors       = ['saki']
  spec.email         = ['sakihet@gmail.com']

  spec.summary       = 'bl is a command line tool for Backlog.'
  spec.description   = 'bl is a command line tool for Backlog.'
  spec.homepage      = 'https://github.com/sakihet/bl'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f|
    f.match(%r{^(test|spec|features)/})
  }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'backlog_kit', '~> 0.16.0'
  spec.add_dependency 'hirb', '~> 0.7.3'
  spec.add_dependency 'hirb-unicode-steakknife', '~> 0.0.8'
  spec.add_dependency 'paint', '~> 2.0'
  spec.add_dependency 'thor', '~> 0.20.0'

  spec.add_development_dependency 'bundler', '~> 1.16.0'
  spec.add_development_dependency 'minitest', '~> 5.10'
  spec.add_development_dependency 'pry', '~> 0.11.2'
  spec.add_development_dependency 'rake', '~> 12.3.0'
  spec.add_development_dependency 'rubocop', '~> 0.51.0'
end
