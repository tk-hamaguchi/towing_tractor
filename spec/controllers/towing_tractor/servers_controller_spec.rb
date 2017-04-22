require 'rails_helper'

module TowingTractor
  RSpec.describe ServersController, type: :controller do
    routes { TowingTractor::Engine.routes }

    let(:servers)      { double(ActiveRecord::Relation) }
    let(:server)       { double(TowingTractor::DockerServer, to_hash: server_hash, id: server_id) }
    let(:server_id)    { double(Integer) }
    let(:server_hash)  { double(Hash) }
    let(:server_name)  { double(String) }
    let(:server_url)   { double(String) }
    let(:server_params) {
      {
        server: {
          name: server_name,
          url:  server_url
        }
      }
    }
    let(:permitted_server_params) {
      params = ActionController::Parameters.new(
        name: server_name.to_s,
        url:  server_url.to_s
      )
      params.permit!
      params
    }

    before do
      allow(DockerServer).to receive(:all).and_return(servers)
      allow(DockerServer).to receive(:find).and_return(server)
      allow(DockerServer).to receive(:create!).and_return(server)
      allow(server).to receive(:update!).and_return(server)
      allow(server).to receive(:destroy!).and_return(server)
    end

    shared_examples 'json_reponse' do |status|
      context 'response' do
        subject { super() ; response }
        it { is_expected.to have_http_status(status || :ok) }
        context 'Content-Type' do
          subject { super().content_type }
          it { is_expected.to eq 'application/json' }
        end
        context 'body' do
          it 'should eq valid JSON' do
            expect{JSON.parse(subject.body)}.to_not raise_error
          end
        end
      end
    end

    shared_examples 'not_found' do
      include_examples 'json_reponse', :not_found
      context 'parsed response body' do
        subject { JSON.parse(super().body) }
        it { is_expected.to have_key('error') }
      end
    end

    shared_examples 'unprocessable_entity' do
      include_examples 'json_reponse', :unprocessable_entity
      context 'parsed response body' do
        subject { JSON.parse(super().body) }
        it { is_expected.to have_key('error') }
      end
    end

    context '#index' do
      subject { get :index }
      context 'with valid params' do
        context 'DockerServer' do
          it { expect(DockerServer).to receive(:all).with(no_args) }
          after { subject }
        end
        context '@servers' do
          subject { super() ; assigns(:servers) }
          it 'should eq expected servers' do
            is_expected.to eq servers
          end
        end
        include_examples 'json_reponse'
      end
    end

    context '#create' do
      subject { post :create, params: server_params }
      context 'with valid params' do
        context 'DockerServer' do
          it 'should receive create!(Permitted-ActionController::Parameters-instance)' do
            expect(DockerServer).to receive(:create!).with(permitted_server_params)
          end
          after { subject }
        end
        context '@server' do
          subject { super() ; assigns(:server) }
          it 'should eq expected server' do
            is_expected.to eq server
          end
        end
        include_examples 'json_reponse', :created
      end

      context 'with invalid params for example,' do
        context 'server was' do
          context 'missing' do
            let(:server_params) { { } }
            context 'then' do
              context 'DockerServer' do
                it 'should not receive create!(any_args)' do
                  expect(DockerServer).to_not receive(:create!).with(any_args)
                end
                after { subject }
              end
              context '@server' do
                subject { super() ; assigns(:server) }
                it { is_expected.to be_nil }
              end
              include_examples 'unprocessable_entity'
            end
          end
        end

        context 'ActiveRecord::RecordInvalid was raised then' do
          let(:dummy_model) { mock_model(TowingTractor::DockerServer) }
          before do
            error = ActiveRecord::RecordInvalid.new(dummy_model)
            allow(DockerServer).to receive(:create!).and_raise(error)
          end
          context '@server' do
            subject { super() ; assigns(:server) }
            it { is_expected.to be_nil }
          end
          include_examples 'unprocessable_entity'
        end

        context 'ActiveRecord::StatementInvalid was raised then' do
          before { allow(DockerServer).to receive(:create!).and_raise(ActiveRecord::StatementInvalid) }
          context '@server' do
            subject { super() ; assigns(:server) }
            it { is_expected.to be_nil }
          end
          include_examples 'unprocessable_entity'
        end

        context 'ActionController::ParameterMissing was raised then' do
          before do
            error = ActionController::ParameterMissing.new({})
            allow(controller).to receive(:server_params).and_raise(error)
          end
          context '@server' do
            subject { super() ; assigns(:server) }
            it { is_expected.to be_nil }
          end
          include_examples 'unprocessable_entity'
        end
      end
    end

    context '#show' do
      subject { get :show, params: { id: server_id } }

      context 'with valid params' do
        context 'DockerServer' do
          it 'should receive find(params[:id])' do
            expect(DockerServer).to receive(:find).with(server_id.to_s)
          end
          after { subject }
        end
        context '@server' do
          subject { super() ; assigns(:server) }
          it 'should eq expected server' do
            is_expected.to eq server
          end
        end
        include_examples 'json_reponse'
      end

      context 'with invalid params for example,' do
        context 'ActiveRecord::RecordNotFound was raised then' do
          before do
            error = ActiveRecord::RecordNotFound.new
            allow(DockerServer).to receive(:find).and_raise(error)
          end
          context '@server' do
            subject { super() ; assigns(:server) }
            it { is_expected.to be_nil }
          end
          include_examples 'not_found'
        end
      end
    end

    context '#update' do
      subject { put :update, params: { id: server_id }.merge(server_params) }
      context 'with valid params' do
        context 'DockerServer' do
          it 'should receive find(params[:id])' do
            expect(DockerServer).to receive(:find).with(server_id.to_s)
          end
          after { subject }
        end

        context 'instance of DockerServer' do
          it 'should receive update!(Permitted-ActionController::Parameters-instance)' do
            expect(server).to receive(:update!).with(permitted_server_params)
          end
          after { subject }
        end

        context '@server' do
          subject { super() ; assigns(:server) }
          it 'should eq expected server' do
            is_expected.to eq server
          end
        end
        include_examples 'json_reponse'
      end

      context 'with invalid params for example,' do
        context 'server was' do
          context 'missing' do
            let(:server_params) { { } }
            context 'then' do
              context 'instance of DockerServer' do
                it 'should not receive update!(any_args)' do
                  expect(server).to_not receive(:update!).with(any_args)
                end
                after { subject }
              end

              context '@server' do
                subject { super() ; assigns(:server) }
                it 'should eq expected server' do
                  is_expected.to eq server
                end
              end
              include_examples 'unprocessable_entity'
            end
          end
        end

        context 'ActiveRecord::RecordNotFound was raised then' do
          before do
            error = ActiveRecord::RecordNotFound.new
            allow(DockerServer).to receive(:find).and_raise(error)
          end
          context '@server' do
            subject { super() ; assigns(:server) }
            it { is_expected.to be_nil }
          end
          include_examples 'not_found'
        end

        context 'ActiveRecord::RecordInvalid was raised then' do
          let(:dummy_model) { mock_model(TowingTractor::DockerServer) }
          before do
            error = ActiveRecord::RecordInvalid.new(dummy_model)
            allow(server).to receive(:update!).and_raise(error)
          end
          context '@server' do
            subject { super() ; assigns(:server) }
            it 'should eq expected server' do
              is_expected.to eq server
            end
          end
          include_examples 'unprocessable_entity'
        end

        context 'ActiveRecord::StatementInvalid was raised then' do
          before { allow(server).to receive(:update!).and_raise(ActiveRecord::StatementInvalid) }
          context '@server' do
            subject { super() ; assigns(:server) }
            it 'should eq expected server' do
              is_expected.to eq server
            end
          end
          include_examples 'unprocessable_entity'
        end

        context 'ActionController::ParameterMissing was raised then' do
          before do
            error = ActionController::ParameterMissing.new({})
            allow(controller).to receive(:server_params).and_raise(error)
          end
          context '@server' do
            subject { super() ; assigns(:server) }
            it 'should eq expected server' do
              is_expected.to eq server
            end
          end
          include_examples 'unprocessable_entity'
        end
      end
    end

    context '#destroy' do
      subject { delete :destroy, params: { id: server_id } }
      context 'with valid params' do
        context 'DockerServer' do
          it 'should receive find(params[:id])' do
            expect(DockerServer).to receive(:find).with(server_id.to_s)
          end
          after { subject }
        end

        context 'instance of DockerServer' do
          it 'should receive destroy!(no_args)' do
            expect(server).to receive(:destroy!).with(no_args)
          end
          after { subject }
        end

        context '@server' do
          subject { super() ; assigns(:server) }
          it 'should eq expected server' do
            is_expected.to eq server
          end
        end
        include_examples 'json_reponse'
      end

      context 'with invalid params for example,' do
        context 'ActiveRecord::RecordNotFound was raised then' do
          before do
            error = ActiveRecord::RecordNotFound.new
            allow(DockerServer).to receive(:find).and_raise(error)
          end
          context '@server' do
            subject { super() ; assigns(:server) }
            it { is_expected.to be_nil }
          end
          include_examples 'not_found'
        end
      end
    end
  end
end
