require 'rails_helper'

RSpec.describe 'PUT /towing_tractor/images/:id', type: :request do

  let(:base_image) { FactoryGirl.create(:docker_image) }
  let(:image_params) { { image: FactoryGirl.attributes_for(:docker_image) } }
  let(:image_id) { base_image.id }

  subject do
    put "/towing_tractor/images/#{image_id}", params: image_params ; response
  end

  context 'with valid request' do
    context 'for example,' do
      context 'fill params' do
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
                context "['name']" do
                  subject { super()['name'] }
                  it { is_expected.to eq image_params[:image][:name] }
                end
                context "['image']" do
                  subject { super()['image'] }
                  it { is_expected.to eq image_params[:image][:image] }
                end
              end
            end
          end
        end
      end

      context 'only :name' do
        before do
          image_image = image_params[:image].delete(:image)
        end
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
                context "['name']" do
                  subject { super()['name'] }
                  it { is_expected.to eq image_params[:image][:name] }
                end
                context "['image']" do
                  subject { super()['image'] }
                  it { is_expected.to eq base_image.image }
                end
              end
            end
          end
        end
      end

      context 'only :image' do
        before do
          image_image = image_params[:image].delete(:name)
        end
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
                context "['name']" do
                  subject { super()['name'] }
                  it { is_expected.to eq base_image.name }
                end
                context "['image']" do
                  subject { super()['image'] }
                  it { is_expected.to eq image_params[:image][:image] }
                end
              end
            end
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

      { 'blank' => '', 'nil' => nil }.each do |k, v|
        context "params[:image][:name] was #{k}" do
          before do
            image_params[:image][:name] = v
          end
          context 'response' do
            it { is_expected.to have_http_status(:unprocessable_entity) }
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
                  it { is_expected.to be_a Hash }
                  it { is_expected.to have_key('name') }
                  it { is_expected.to_not have_key('image') }
                  context "['name']" do
                    subject { super()['name'] }
                    it { is_expected.to be_a Array }
                    it { is_expected.to include "can't be blank" }
                  end
                end
              end
            end
          end
        end
      end

      { 'blank' => '', 'nil' => nil }.each do |k, v|
        context "params[:image][:image] was #{k}" do
          before do
            image_params[:image][:image] = v
          end
          context 'response' do
            it { is_expected.to have_http_status(:unprocessable_entity) }
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
                  it { is_expected.to be_a Hash }
                  it { is_expected.to have_key('image') }
                  it { is_expected.to_not have_key('name') }
                  context "['image']" do
                    subject { super()['image'] }
                    it { is_expected.to be_a Array }
                    it { is_expected.to include "can't be blank" }
                  end
                end
              end
            end
          end
        end
      end

      context 'params[:image][:image] was conflicted' do
        before do
          post '/towing_tractor/images', params: image_params
        end
        context 'response' do
          it { is_expected.to have_http_status(:unprocessable_entity) }
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
                it { is_expected.to be_a Hash }
                it { is_expected.to have_key('image') }
                it { is_expected.to_not have_key('name') }
                context "['image']" do
                  subject { super()['image'] }
                  it { is_expected.to be_a Array }
                  it { is_expected.to include 'has already been taken' }
                end
              end
            end
          end
        end
      end

      { 'blank' => '', 'empty' => {}, 'nil' => nil }.each do |k, v|
        context "params[:image] was #{k}" do
          before do
            image_params[:image] = v
          end
          context 'response' do
            it { is_expected.to have_http_status(:unprocessable_entity) }
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
                  it { is_expected.to eq 'param is missing or the value is empty: image' }
                end
              end
            end
          end
        end
      end
    end
  end
end
