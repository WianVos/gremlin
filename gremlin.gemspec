# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','gremlin','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'gremlin'
  s.version = Gremlin::VERSION
  s.author = 'Wian Vos'
  s.email = 'w.vos@xebia.com'
  s.homepage = 'https://github.com/xebia-puppet/gremlin'
  s.platform = Gem::Platform::RUBY
  s.summary = 'gremlin infrastructure orchestration tool'
  s.description = <<eos
                  This is a kick-ass orchestration tool based on sinatra and dynflow
eos
  s.license = 'MIT'
  s.files = `git ls-files`.split("\n")
  s.require_paths << 'lib'
  s.has_rdoc = false
  s.bindir = 'bin'
  #s.executables << 'gremlin'
  s.required_ruby_version = '~> 2.0'
  s.add_development_dependency('rake', '~> 10.2' )
  s.add_development_dependency('rdoc', '~> 4.1')
  s.add_development_dependency('shotgun', '0.9')
  s.add_development_dependency('passenger', '~> 4.0')
  s.add_development_dependency('rspec' ,'~> 2.14')
  s.add_development_dependency('capybara', '~> 2.2')
  s.add_runtime_dependency('sinatra','1.4.5')
  s.add_runtime_dependency('sinatra-contrib','1.4.2')
  s.add_runtime_dependency('dynflow', '0.6.2')
  s.add_runtime_dependency('rack', '1.5.2')
  s.add_runtime_dependency('daemons')
  s.add_runtime_dependency('sqlite3')
  s.add_runtime_dependency('sequel', '4.1.0')
  s.add_runtime_dependency('pry')
  s.add_runtime_dependency('fog')
end