require 'rails_helper'

RSpec.describe 'routes for TowingTractor::ImagesController', type: :routing do
  routes { TowingTractor::Engine.routes }
  let(:image) { FactoryGirl.create(:docker_image) }
  let(:image_id) { image.id }

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

  context 'GET /images/:id' do
    subject { get "/images/#{image_id}" }
    it { is_expected.to be_routable }
    context 'for example,' do
      context '/images/1234' do
        let(:image_id) { '1234' }
        it { is_expected.to route_to controller: 'towing_tractor/images', id: '1234', action: 'show', format: :json }
      end
      context '/images/9' do
        let(:image_id) { '9' }
        it { is_expected.to route_to controller: 'towing_tractor/images', id: '9', action: 'show', format: :json }
      end
    end
  end

  context 'PUT /images/:id' do
    subject { put "/images/#{image_id}" }
    it { is_expected.to be_routable }
    context 'for example,' do
      context '/images/1234' do
        let(:image_id) { '1234' }
        it { is_expected.to route_to controller: 'towing_tractor/images', id: '1234', action: 'update', format: :json }
      end
      context '/images/9' do
        let(:image_id) { '9' }
        it { is_expected.to route_to controller: 'towing_tractor/images', id: '9', action: 'update', format: :json }
      end
    end
  end

  context 'DELETE /images/:id' do
    subject { delete "/images/#{image_id}" }
    it { is_expected.to be_routable }
    context 'for example,' do
      context '/images/1234' do
        let(:image_id) { '1234' }
        it { is_expected.to route_to controller: 'towing_tractor/images', id: '1234', action: 'destroy', format: :json }
      end
      context '/images/9' do
        let(:image_id) { '9' }
        it { is_expected.to route_to controller: 'towing_tractor/images', id: '9', action: 'destroy', format: :json }
      end
    end
  end
end
