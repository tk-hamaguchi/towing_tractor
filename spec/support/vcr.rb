require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  #c.default_cassette_options = { record: :new_episodes }
  c.default_cassette_options = { record: :none }
end


RSpec.configure do |c|
  c.around(:context) do |context|
    VCR.use_cassette('default') do
      context.run
    end
  end
end
