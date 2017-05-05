require 'rails_helper'

RSpec.describe 'routes for TowingTractor::Servers::ContainersController', type: :routing do
  routes { TowingTractor::Engine.routes }
  let(:server) { FactoryGirl.create(:docker_server) }
  let(:container) { FactoryGirl.create(:docker_container) }
  let(:server_id) { server.id }
  let(:container_id) { container.id }

  context 'GET /servers/:server_id/containers' do
    subject { get "/servers/#{server_id}/containers" }
    it { is_expected.to be_routable }
    context 'for example,' do
      context '/servers/9/containers' do
        let(:server_id) { '9' }
        it { is_expected.to route_to controller: 'towing_tractor/servers/containers', action: 'index', format: :json, server_id: '9' }
      end
      context '/servers/821/containers' do
        let(:server_id) { '821' }
        it { is_expected.to route_to controller: 'towing_tractor/servers/containers', action: 'index', format: :json, server_id: '821' }
      end
    end
  end

  context 'POST /servers/:server_id/containers' do
    subject { post "/servers/#{server_id}/containers" }
    it { is_expected.to be_routable }
    context 'for example,' do
      context '/servers/9/containers' do
        let(:server_id) { '9' }
        it { is_expected.to route_to controller: 'towing_tractor/servers/containers', action: 'create', format: :json, server_id: '9' }
      end
      context '/servers/821/containers' do
        let(:server_id) { '821' }
        it { is_expected.to route_to controller: 'towing_tractor/servers/containers', action: 'create', format: :json, server_id: '821' }
      end
    end
  end

  context 'GET /servers/:server_id/containers/:id' do
    subject { get "/servers/#{server_id}/containers/#{container_id}" }
    it { is_expected.to be_routable }
    context 'for example,' do
      context '/servers/9/containers/123' do
        let(:server_id) { '9' }
        let(:container_id) { '123' }
        it { is_expected.to route_to controller: 'towing_tractor/servers/containers', action: 'show', format: :json, server_id: '9', id: '123' }
      end
      context '/servers/1044/containers/3' do
        let(:server_id) { '1044' }
        let(:container_id) { '3' }
        it { is_expected.to route_to controller: 'towing_tractor/servers/containers', action: 'show', format: :json, server_id: '1044', id: '3' }
      end
    end
  end

  context 'PUT /servers/:server_id/containers/:id' do
    subject { put "/servers/#{server_id}/containers/#{container_id}" }
    it { is_expected.to be_routable }
    context 'for example,' do
      context '/servers/9/containers/123' do
        let(:server_id) { '9' }
        let(:container_id) { '123' }
        it { is_expected.to route_to controller: 'towing_tractor/servers/containers', action: 'update', format: :json, server_id: '9', id: '123' }
      end
      context '/servers/1044/containers/3' do
        let(:server_id) { '1044' }
        let(:container_id) { '3' }
        it { is_expected.to route_to controller: 'towing_tractor/servers/containers', action: 'update', format: :json, server_id: '1044', id: '3' }
      end
    end
  end

  context 'DELETE /servers/:server_id/containers/:id' do
    subject { delete "/servers/#{server_id}/containers/#{container_id}" }
    it { is_expected.to be_routable }
    context 'for example,' do
      context '/servers/9/containers/123' do
        let(:server_id) { '9' }
        let(:container_id) { '123' }
        it { is_expected.to route_to controller: 'towing_tractor/servers/containers', action: 'destroy', format: :json, server_id: '9', id: '123' }
      end
      context '/servers/1044/containers/3' do
        let(:server_id) { '1044' }
        let(:container_id) { '3' }
        it { is_expected.to route_to controller: 'towing_tractor/servers/containers', action: 'destroy', format: :json, server_id: '1044', id: '3' }
      end
    end
  end
end
