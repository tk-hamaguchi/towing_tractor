require 'rails_helper'

RSpec.describe 'routes for TowingTractor::ServersController', type: :routing do
  routes { TowingTractor::Engine.routes }

  context 'GET /servers' do
    subject { get '/servers' }
    it { is_expected.to be_routable }
    it { is_expected.to route_to controller: 'towing_tractor/servers', action: 'index', format: :json }
  end

  context 'POST /servers' do
    subject { post '/servers' }
    it { is_expected.to be_routable }
    it { is_expected.to route_to controller: 'towing_tractor/servers', action: 'create', format: :json }
  end

  context 'GET /servers/1' do
    subject { get '/servers/1' }
    it { is_expected.to be_routable }
    it { is_expected.to route_to controller: 'towing_tractor/servers', id: '1', action: 'show', format: :json }
  end

  context 'PUT /servers/1' do
    subject { put '/servers/1' }
    it { is_expected.to be_routable }
    it { is_expected.to route_to controller: 'towing_tractor/servers', id: '1', action: 'update', format: :json }
  end

  context 'DELETE /servers/1' do
    subject { delete '/servers/1' }
    it { is_expected.to be_routable }
    it { is_expected.to route_to controller: 'towing_tractor/servers', id: '1', action: 'destroy', format: :json }
  end
end
