require 'rails_helper'

module TowingTractor
  RSpec.describe ImagesController, type: :controller do
    routes { TowingTractor::Engine.routes }

    let(:images)      { double(ActiveRecord::Relation) }
    let(:image)       { double(TowingTractor::DockerImage, to_hash: image_hash, id: image_id) }
    let(:image_id)    { double(Integer) }
    let(:image_hash)  { double(Hash) }
    let(:image_name)  { double(String) }
    let(:image_image) { double(String) }
    let(:image_params) {
      {
        image: {
          name:  image_name,
          image: image_image
        }
      }
    }
    let(:permitted_image_params) {
      params = ActionController::Parameters.new(
        name:  image_name.to_s,
        image: image_image.to_s
      )
      params.permit!
      params
    }

    before do
      allow(DockerImage).to receive(:all).and_return(images)
      allow(DockerImage).to receive(:find).and_return(image)
      allow(DockerImage).to receive(:create!).and_return(image)
      allow(image).to receive(:update!).and_return(image)
      allow(image).to receive(:destroy!).and_return(image)
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
        context 'DockerImage' do
          it { expect(DockerImage).to receive(:all).with(no_args) }
          after { subject }
        end
        context '@images' do
          subject { super() ; assigns(:images) }
          it 'should eq expected images' do
            is_expected.to eq images
          end
        end
        include_examples 'json_reponse'
      end
    end

    context '#create' do
      subject { post :create, params: image_params }
      context 'with valid params' do
        context 'DockerImage' do
          it 'should receive create!(Permitted-ActionController::Parameters-instance)' do
            expect(DockerImage).to receive(:create!).with(permitted_image_params)
          end
          after { subject }
        end
        context '@image' do
          subject { super() ; assigns(:image) }
          it 'should eq expected image' do
            is_expected.to eq image
          end
        end
        include_examples 'json_reponse', :created
      end

      context 'with invalid params for example,' do
        context 'image was' do
          context 'missing' do
            let(:image_params) { { } }
            context 'then' do
              context 'DockerImage' do
                it 'should not receive create!(any_args)' do
                  expect(DockerImage).to_not receive(:create!).with(any_args)
                end
                after { subject }
              end
              context '@image' do
                subject { super() ; assigns(:image) }
                it { is_expected.to be_nil }
              end
              include_examples 'unprocessable_entity'
            end
          end
        end

        context 'ActiveRecord::RecordInvalid was raised then' do
          let(:dummy_model) { mock_model(TowingTractor::DockerImage) }
          before do
            error = ActiveRecord::RecordInvalid.new(dummy_model)
            allow(DockerImage).to receive(:create!).and_raise(error)
          end
          context '@image' do
            subject { super() ; assigns(:image) }
            it { is_expected.to be_nil }
          end
          include_examples 'unprocessable_entity'
        end

        context 'ActiveRecord::StatementInvalid was raised then' do
          before { allow(DockerImage).to receive(:create!).and_raise(ActiveRecord::StatementInvalid) }
          context '@image' do
            subject { super() ; assigns(:image) }
            it { is_expected.to be_nil }
          end
          include_examples 'unprocessable_entity'
        end

        context 'ActionController::ParameterMissing was raised then' do
          before do
            error = ActionController::ParameterMissing.new({})
            allow(controller).to receive(:image_params).and_raise(error)
          end
          context '@image' do
            subject { super() ; assigns(:image) }
            it { is_expected.to be_nil }
          end
          include_examples 'unprocessable_entity'
        end
      end
    end

    context '#show' do
      subject { get :show, params: { id: image_id } }

      context 'with valid params' do
        context 'DockerImage' do
          it 'should receive find(params[:id])' do
            expect(DockerImage).to receive(:find).with(image_id.to_s)
          end
          after { subject }
        end
        context '@image' do
          subject { super() ; assigns(:image) }
          it 'should eq expected image' do
            is_expected.to eq image
          end
        end
        include_examples 'json_reponse'
      end

      context 'with invalid params for example,' do
        context 'ActiveRecord::RecordNotFound was raised then' do
          before do
            error = ActiveRecord::RecordNotFound.new
            allow(DockerImage).to receive(:find).and_raise(error)
          end
          context '@image' do
            subject { super() ; assigns(:image) }
            it { is_expected.to be_nil }
          end
          include_examples 'not_found'
        end
      end
    end

    context '#update' do
      subject { put :update, params: { id: image_id }.merge(image_params) }
      context 'with valid params' do
        context 'DockerImage' do
          it 'should receive find(params[:id])' do
            expect(DockerImage).to receive(:find).with(image_id.to_s)
          end
          after { subject }
        end

        context 'instance of DockerImage' do
          it 'should receive update!(Permitted-ActionController::Parameters-instance)' do
            expect(image).to receive(:update!).with(permitted_image_params)
          end
          after { subject }
        end
        context '@image' do
          subject { super() ; assigns(:image) }
          it 'should eq expected image' do
            is_expected.to eq image
          end
        end
        include_examples 'json_reponse'
      end

      context 'with invalid params for example,' do
        context 'image was' do
          context 'missing' do
            let(:image_params) { { } }
            context 'then' do
              context 'instance of DockerImage' do
                it 'should not receive update!(any_args)' do
                  expect(image).to_not receive(:update!).with(any_args)
                end
                after { subject }
              end
              context '@image' do
                subject { super() ; assigns(:image) }
                it 'should eq expected image' do
                  is_expected.to eq image
                end
              end
              include_examples 'unprocessable_entity'
            end
          end
        end

        context 'ActiveRecord::RecordNotFound was raised then' do
          before do
            error = ActiveRecord::RecordNotFound.new
            allow(DockerImage).to receive(:find).and_raise(error)
          end
          context '@image' do
            subject { super() ; assigns(:image) }
            it { is_expected.to be_nil }
          end
          include_examples 'not_found'
        end

        context 'ActiveRecord::RecordInvalid was raised then' do
          let(:dummy_model) { mock_model(TowingTractor::DockerImage) }
          before do
            error = ActiveRecord::RecordInvalid.new(dummy_model)
            allow(image).to receive(:update!).and_raise(error)
          end
          context '@image' do
            subject { super() ; assigns(:image) }
            it 'should eq expected image' do
              is_expected.to eq image
            end
          end
          include_examples 'unprocessable_entity'
        end

        context 'ActiveRecord::StatementInvalid was raised then' do
          before { allow(image).to receive(:update!).and_raise(ActiveRecord::StatementInvalid) }
          context '@image' do
            subject { super() ; assigns(:image) }
            it 'should eq expected image' do
              is_expected.to eq image
            end
          end
          include_examples 'unprocessable_entity'
        end

        context 'ActionController::ParameterMissing was raised then' do
          before do
            error = ActionController::ParameterMissing.new({})
            allow(controller).to receive(:image_params).and_raise(error)
          end
          context '@image' do
            subject { super() ; assigns(:image) }
            it 'should eq expected image' do
              is_expected.to eq image
            end
          end
          include_examples 'unprocessable_entity'
        end
      end
    end

    context '#destroy' do
      subject { delete :destroy, params: { id: image_id } }
      context 'with valid params' do
        context 'DockerImage' do
          it 'should receive find(params[:id])' do
            expect(DockerImage).to receive(:find).with(image_id.to_s)
          end
          after { subject }
        end

        context 'instance of DockerImage' do
          it 'should receive destroy!(no_args)' do
            expect(image).to receive(:destroy!).with(no_args)
          end
          after { subject }
        end
        context '@image' do
          subject { super() ; assigns(:image) }
          it 'should eq expected image' do
            is_expected.to eq image
          end
        end
        include_examples 'json_reponse'
      end

      context 'with invalid params for example,' do
        context 'ActiveRecord::RecordNotFound was raised then' do
          before do
            error = ActiveRecord::RecordNotFound.new
            allow(DockerImage).to receive(:find).and_raise(error)
          end
          context '@image' do
            subject { super() ; assigns(:image) }
            it { is_expected.to be_nil }
          end
          include_examples 'not_found'
        end
      end
    end
  end
end
