$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'towing_tractor/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'towing_tractor'
  s.version     = TowingTractor::VERSION
  s.authors     = ['Takahiro HAMAGUCHI']
  s.email       = ['tk.hamaguchi@gmail.com']
  s.homepage    = 'https://github.com/tk-hamaguchi/towing_tractor'
  s.summary     = 'Docker controller plugin for Rails'
  s.description = 'Docker controller plugin for Rails.'
  s.license     = 'MIT'

  s.files      = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'rails',      '~> 5.1.0.rc1'
  s.add_dependency 'docker-api', '~> 1.33'
  s.add_dependency 'jbuilder',   '~> 2.6'
end

