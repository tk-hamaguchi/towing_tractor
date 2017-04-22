FactoryGirl.define do
  factory :docker_image, class: 'TowingTractor::DockerImage' do
    name  { Faker::Pokemon.name }
    image { Faker::Internet.domain_name + '/' + name.downcase + ':latest' }
  end
end
