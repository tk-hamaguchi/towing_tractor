require 'rails_helper'

RSpec.feature 'Container management', type: :feature do
  scenario 'Regist new Image/Server and manage Container' do

    ##--- Regist DockerImage ----------------------------------------------------

    page.driver.post '/towing_tractor/images',
      { image: { image: 'alpine:latest', name: 'base' } }

    expect(page.driver.response.status).to eq 201
    expect(page.driver.response.content_type).to eq 'application/json; charset=utf-8'
    expect{JSON.parse(page.driver.response.body)}.to_not raise_error

    res = JSON.parse(page.driver.response.body)
    expect(res).to have_key 'image'

    image = res['image']

    ##--- Regist DockerServer ----------------------------------------------------

    page.driver.post '/towing_tractor/servers',
      { server: { name: 'staging', url: 'http://docker-api.example.com:2376/' } }

    expect(page.driver.response.status).to eq 201
    expect(page.driver.response.content_type).to eq 'application/json; charset=utf-8'
    expect{JSON.parse(page.driver.response.body)}.to_not raise_error

    res = JSON.parse(page.driver.response.body)
    expect(res).to have_key 'server'

    server = res['server']

    ##--- Create DockerContainer ------------------------------------------------

    page.driver.post "/towing_tractor/servers/#{server['id']}/containers",
      { container: { image_id: image['id'], env: { 'TZ': 'JST-9' }.to_json, cmd: %w(date).to_json } }

    expect(page.driver.response.status).to eq 201
    expect(page.driver.response.content_type).to eq 'application/json; charset=utf-8'
    expect{JSON.parse(page.driver.response.body)}.to_not raise_error

    res = JSON.parse(page.driver.response.body)
    expect(res).to have_key 'container'

    container = res['container']

    ##--- Start DockerContainer ------------------------------------------------

    page.driver.put "/towing_tractor/servers/#{server['id']}/containers/#{container['id']}/start"
    expect(page.driver.response.status).to eq 202

    ##--- Fetch logs from DockerContainer ------------------------------------------------

    page.driver.get "/towing_tractor/servers/#{server['id']}/containers/#{container['id']}/logs"

    expect(page.driver.response.status).to eq 200
    expect(page.driver.response.content_type).to eq 'application/json; charset=utf-8'
    expect{JSON.parse(page.driver.response.body)}.to_not raise_error

    res = JSON.parse(page.driver.response.body)
    expect(res).to have_key 'container'
    expect(res['container']).to have_key 'logs'

    expect(res['container']['logs']).to_not be_blank

    ##--- Stop DockerContainer ------------------------------------------------

    page.driver.put "/towing_tractor/servers/#{server['id']}/containers/#{container['id']}/stop"
    expect(page.driver.response.status).to eq 202

    ##--- Destroy DockerContainer ------------------------------------------------

    page.driver.delete "/towing_tractor/servers/#{server['id']}/containers/#{container['id']}"
    expect(page.driver.response.status).to eq 200

    page.driver.get "/towing_tractor/servers/#{server['id']}/containers/#{container['id']}"
    expect(page.driver.response.status).to eq 404

  end
end
