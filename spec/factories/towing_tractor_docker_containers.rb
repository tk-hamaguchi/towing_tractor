FactoryGirl.define do
  factory :docker_container, class: 'TowingTractor::DockerContainer' do
    image_id 1
    env "MyText"
    cmd "MyText"
    last_keepalived_at "2017-05-05 12:58:52"
  end
end
