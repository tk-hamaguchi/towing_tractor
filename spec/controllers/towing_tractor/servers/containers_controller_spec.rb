require 'rails_helper'

module TowingTractor
  RSpec.describe Servers::ContainersController, type: :controller do
    routes { TowingTractor::Engine.routes }

    let(:server) { double(TowingTractor::DockerServer, id: server_id) }
    let(:server_id) { double(Integer) }
    let(:containers) { double(ActiveRecord::Relation) }
    let(:container) { double(TowingTractor::DockerContainer, destroy: self) }
    let(:container_id) { double(Integer) }
    let(:image_id) { double(Integer) }

    before do
      allow(TowingTractor::DockerContainer).to receive(:where).and_return(containers)
      allow(TowingTractor::DockerContainer).to receive(:find).and_return(container)
      allow(TowingTractor::DockerContainer).to receive(:create!).and_return(container)
      allow(TowingTractor::DockerServer).to receive(:find).and_return(server)
    end

    context '#index' do
      subject { get :index, params: { server_id: server_id } }
      it { is_expected.to be_success }
      context 'TowingTractor::DockerContainer' do
        it { expect(TowingTractor::DockerContainer).to receive(:where).with(server_id: server_id.to_s) ; subject }
      end
      context 'response' do
        subject { get :index, params: { server_id: server_id } ; response }
        it { is_expected.to have_http_status(:ok) }
      end
      context '@containers' do
        subject { super() ; assigns(:containers) }
        it 'should eq the result of TowingTractor::DockerContainer.where' do
          is_expected.to eq containers
        end
      end
    end

    context '#create' do
      let(:params) { { container: { image_id: image_id }, server_id: server_id } }
      subject { post :create, params: params }
      it { is_expected.to be_success }
      context 'TowingTractor::DockerContainer' do
        it {
          expect(TowingTractor::DockerContainer).to receive(:create!).with(
            ActionController::Parameters.new(
              'image_id':  image_id.to_s,
              'server_id': server_id
            ).permit!
          )
          subject
        }
      end
      context 'response' do
        subject { post :create, params: params ; response }
        it { is_expected.to have_http_status(:created) }
      end
      context '@container' do
        subject { super() ; assigns(:container) }
        it 'should eq the result of TowingTractor::DockerContainer.create' do
          is_expected.to eq container
        end
      end
    end

    context '#show' do
      let(:params) { { id: container_id, server_id: server_id } }
      subject { get :show, params: params }
      it { is_expected.to be_success }
      context 'TowingTractor::DockerContainer' do
        it { expect(TowingTractor::DockerContainer).to receive(:find).with(container_id.to_s, condition: { server_id: server_id.to_s }) ; subject }
      end
      context 'response' do
        subject { get :show, params: params ; response }
        it { is_expected.to have_http_status(:ok) }
      end
      context '@container' do
        subject { super() ; assigns(:container) }
        it 'should eq the result of TowingTractor::DockerContainer.find' do
          is_expected.to eq container
        end
      end
    end

    context '#destroy' do
      let(:params) { { id: container_id, server_id: server_id } }
      subject { delete :destroy, params: params }
      it { is_expected.to be_success }
      context 'TowingTractor::DockerContainer' do
        it { expect(TowingTractor::DockerContainer).to receive(:find).with(container_id.to_s, condition: { server_id: server_id.to_s }) ; subject }
      end
      context 'response' do
        subject { delete :destroy, params: params ; response }
        it { is_expected.to have_http_status(:ok) }
      end
      context '@container' do
        subject { super() ; assigns(:container) }
        it 'should eq the result of TowingTractor::DockerContainer.find' do
          is_expected.to eq container
        end
        it { expect(container).to receive(:destroy).with(no_args) ; subject }
      end
    end

  end
end
