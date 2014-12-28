# -*- mode: ruby; encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'ls_stash'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY

  s.authors     = ['Chris Fordham']
  s.email       = 'chris@fordham-nagy.id.au'
  s.homepage    = 'https://github.com/flaccid/ls_stash'
  s.licenses    = ['Apache-2.0']
  s.summary     = %(Atlassian Stash listing tool.)
  s.description = %(A command line tool that
                    lists objects from Atlassian Stash.)

  s.add_runtime_dependency 'thor', '~> 0'

  s.files = Dir.glob('bin/*') +
    Dir.glob('lib/*.rb') +
    Dir.glob('lib/*/*.rb')

  s.executables = Dir.glob('bin/*').map { |f| File.basename(f) }
end
