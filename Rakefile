require 'bundler/gem_tasks'
require 'rake/extensiontask'

spec = Gem::Specification.load('copybook_utils.gemspec')
Rake::ExtensionTask.new('convert_methods', spec)
