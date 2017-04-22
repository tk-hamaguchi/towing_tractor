require 'rails_helper'

RSpec.describe 'DELETE /towing_tractor/images/:id', type: :request do

  let(:image) { FactoryGirl.create(:docker_image) }
  let(:image_id) { image.id }

  subject do
    delete "/towing_tractor/images/#{image_id}" ; response
  end

  context 'with valid request' do
    context 'response' do
      it { is_expected.to be_success }
      it { is_expected.to have_http_status(:ok) }
      context 'Content-Type' do
        subject { super().content_type }
        it { is_expected.to eq 'application/json' }
      end
      context 'body' do
        subject { super().body }
        it 'should be valid JSON' do
          expect{JSON.parse(subject)}.to_not raise_error
        end
        context 'parsed' do
          subject { JSON.parse(super()) }
          it { is_expected.to be_a Hash }
          it { is_expected.to have_key('image') }
          context "['image']" do
            subject { super()['image'] }
            it { is_expected.to be_a Hash }
            it { is_expected.to have_key('id') }
            it { is_expected.to have_key('name') }
            it { is_expected.to have_key('image') }
            it { is_expected.to have_key('created_at') }
            it { is_expected.to have_key('updated_at') }
          end
        end
      end
    end
  end

  context 'with invalid request' do
    context 'for example,' do
      context 'params[:id] was unknown image id' do
        let(:image_id) { 2147483647 }
        context 'response' do
          it { is_expected.to have_http_status(:not_found) }
          context 'Content-Type' do
            subject { super().content_type }
            it { is_expected.to eq 'application/json' }
          end
          context 'body' do
            subject { super().body }
            it 'should be valid JSON' do
              expect{JSON.parse(subject)}.to_not raise_error
            end
            context 'parsed' do
              subject { JSON.parse(super()) }
              it { is_expected.to be_a Hash }
              it { is_expected.to have_key('error') }
              context "['error']" do
                subject { super()['error'] }
                it { is_expected.to be_a String }
                it { is_expected.to eq "Couldn't find TowingTractor::DockerImage with 'id'=2147483647" }
              end
            end
          end
        end
      end
    end
  end
end
