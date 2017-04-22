require 'rails_helper'

RSpec.describe 'GET /towing_tractor/images', type: :request do

  before do
    FactoryGirl.create_list(:docker_image, 10)
  end

  subject do
    get '/towing_tractor/images' ; response
  end

  context 'with valid request' do
    context 'for example,' do
      context 'minimum params' do
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
              it { is_expected.to have_key('images') }
              context "['images']" do
                subject { super()['images'] }
                it { is_expected.to be_a Array }
                context 'length' do
                  subject { super().length }
                  it { is_expected.to eq 10 }
                end
                context 'items' do
                  subject { super().first }
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
      end
    end
  end
end
