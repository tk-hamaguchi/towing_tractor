require 'rails_helper'

RSpec.describe 'routes for TowingTractor::ServersController', type: :routing do
  routes { TowingTractor::Engine.routes }
  let(:server) { FactoryGirl.create(:docker_server) }
  let(:server_id) { server.id }

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

  context 'GET /servers/:id' do
    subject { get "/servers/#{server_id}" }
    it { is_expected.to be_routable }
    context 'for example,' do
      context '/servers/1234' do
        let(:server_id) { '1234' }
        it { is_expected.to route_to controller: 'towing_tractor/servers', id: '1234', action: 'show', format: :json }
      end
      context '/servers/9' do
        let(:server_id) { '9' }
        it { is_expected.to route_to controller: 'towing_tractor/servers', id: '9', action: 'show', format: :json }
      end
    end
  end

  context 'PUT /servers/:id' do
    subject { put "/servers/#{server_id}" }
    it { is_expected.to be_routable }
    context 'for example,' do
      context '/servers/1234' do
        let(:server_id) { '1234' }
        it { is_expected.to route_to controller: 'towing_tractor/servers', id: '1234', action: 'update', format: :json }
      end
      context '/servers/9' do
        let(:server_id) { '9' }
        it { is_expected.to route_to controller: 'towing_tractor/servers', id: '9', action: 'update', format: :json }
      end
    end
  end

  context 'DELETE /servers/:id' do
    subject { delete "/servers/#{server_id}" }
    it { is_expected.to be_routable }
    context 'for example,' do
      context '/servers/1234' do
        let(:server_id) { '1234' }
        it { is_expected.to route_to controller: 'towing_tractor/servers', id: '1234', action: 'destroy', format: :json }
      end
      context '/servers/9' do
        let(:server_id) { '9' }
        it { is_expected.to route_to controller: 'towing_tractor/servers', id: '9', action: 'destroy', format: :json }
      end
    end
  end
end
