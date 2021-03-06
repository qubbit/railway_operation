# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'railway_operation/version'

Gem::Specification.new do |spec|
  spec.name          = 'railway_operation'
  spec.version       = RailwayOperation::VERSION
  spec.authors       = ['Felix Flores']
  spec.email         = ['felixflores@gmail.com']

  spec.summary       = 'This is a an implementation of the railway ' \
                       'oriented programming pattern in ruby.'

  spec.description   = 'This gem allows you to declare an execution ' \
                       'tree for executing a series of methods and commands.'

  spec.homepage      = 'https://github.com/felixflores/railway_operation/'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set
  # the 'allowed_push_host' to allow pushing to a single host or delete
  # this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'ruby-graphviz'
  spec.add_runtime_dependency 'ruby_deep_clone'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'pry-doc'
  spec.add_development_dependency 'pry-rescue'
  spec.add_development_dependency 'pry-clipboard'
  spec.add_development_dependency 'pry-stack_explorer'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'
end
