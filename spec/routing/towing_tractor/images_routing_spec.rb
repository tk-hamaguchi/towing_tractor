require 'rails_helper'

RSpec.describe 'routes for TowingTractor::ImagesController', type: :routing do
  routes { TowingTractor::Engine.routes }

  context 'GET /images' do
    subject { get '/images' }
    it { is_expected.to be_routable }
    it { is_expected.to route_to controller: 'towing_tractor/images', action: 'index', format: :json }
  end

  context 'POST /images' do
    subject { post '/images' }
    it { is_expected.to be_routable }
    it { is_expected.to route_to controller: 'towing_tractor/images', action: 'create', format: :json }
  end

  context 'GET /images/1' do
    subject { get '/images/1' }
    it { is_expected.to be_routable }
    it { is_expected.to route_to controller: 'towing_tractor/images', id: '1', action: 'show', format: :json }
  end

  context 'PUT /images/1' do
    subject { put '/images/1' }
    it { is_expected.to be_routable }
    it { is_expected.to route_to controller: 'towing_tractor/images', id: '1', action: 'update', format: :json }
  end

  context 'DELETE /images/1' do
    subject { delete '/images/1' }
    it { is_expected.to be_routable }
    it { is_expected.to route_to controller: 'towing_tractor/images', id: '1', action: 'destroy', format: :json }
  end
end
