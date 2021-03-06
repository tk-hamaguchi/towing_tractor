require 'docker'

module TowingTractor
  class Engine < ::Rails::Engine
    isolate_namespace TowingTractor
    config.generators.api_only = true

    Docker.logger = Rails.logger

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
