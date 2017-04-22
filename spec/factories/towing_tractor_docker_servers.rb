FactoryGirl.define do
  factory :docker_server, class: 'TowingTractor::DockerServer' do
    name { Faker::Pokemon.name }
    url  { Faker::Internet.domain_name }
  end
end
