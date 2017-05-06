FactoryGirl.define do
  factory :docker_container, class: 'TowingTractor::DockerContainer' do
    image_id  { FactoryGirl.create(:docker_image).id }
    server_id { FactoryGirl.create(:docker_server).id }
    env       { { hoge: 'FUGA', puki: 123 }.to_json }
    cmd       { '"date"' }
  end
end
