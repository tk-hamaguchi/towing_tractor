require 'rails_helper'

module TowingTractor
  RSpec.describe DockerContainer, type: :model do
    let(:docker_container) { FactoryGirl.create(:docker_container) }
    subject { docker_container }

    let(:real_container) { double(Docker::Container, id: c_id, stop: true, start: true, logs: c_log, info: {'State' => { 'Running' => running }}) }
    let(:c_id) { double(String).to_s }
    let(:c_log) { double(String) }
    let(:running) { true }
    let(:conn) { double(Docker::Connection) }

    before do
      allow(Docker::Container).to receive(:get).and_return(real_container)
      allow(Docker::Container).to receive(:create).and_return(real_container)
      allow(Docker::Connection).to receive(:new).and_return(conn)
      allow(real_container).to receive(:delete).and_return(true)
    end

    context '#container' do
      subject { super().container }
      it { is_expected.to eq real_container }
      it 'then Docker::Container should receive get with container_id and server.connection' do
        expect(Docker::Container).to receive(:get).with(c_id, {}, conn)
        subject
      end
    end

    context 'association' do
      it { is_expected.to belong_to :image }
      it { is_expected.to belong_to :server }
    end

    context ':image_id' do
      it { is_expected.to validate_presence_of(:image_id) }
    end

    context ':server_id' do
      it { is_expected.to validate_presence_of(:server_id) }
    end

    context '#running?' do
      subject { super().running? }
      it { is_expected.to eq running }
      it { expect{subject}.to_not raise_error }
    end

    context '#logs' do
      subject { super().logs }
      it 'should eq expected log string' do
        is_expected.to eq c_log
      end
      it { expect{subject}.to_not raise_error }
    end

    context '#start' do
      subject { super().start }
      it 'should eq self' do
        is_expected.to eq docker_container
      end
      it { expect{subject}.to_not raise_error }
    end

    context '#stop' do
      subject { super().stop }
      it 'should eq self' do
        is_expected.to eq docker_container
      end
      it { expect{subject}.to_not raise_error }
    end

    context '#destroy' do
      subject { super().destroy }
      it 'should call delete' do
        expect(real_container).to receive(:delete).with(force: true)
        subject
      end
    end

    context 'with new record' do
      let(:docker_container) { FactoryGirl.build(:docker_container) }
      subject { docker_container }
      context '#container' do
        subject { super().container }
        it { expect{subject}.to raise_error ArgumentError }
      end

      context '#running?' do
        subject { super().running? }
        it { expect{subject}.to raise_error ArgumentError }
      end

      context '#logs' do
        subject { super().logs }
        it { expect{subject}.to raise_error ArgumentError }
      end

      context '#start' do
        subject { super().start }
        it { expect{subject}.to raise_error ArgumentError }
      end

      context '#stop' do
        subject { super().stop }
        it { expect{subject}.to raise_error ArgumentError }
      end

      context '#save' do
        subject { super().save }
        it { expect{subject}.to_not raise_error }
        it 'should set :container_id' do
          subject
          expect(docker_container.container_id).to_not be_blank
        end
        context 'then Docker::Container' do
          it 'should receive :create with expected option and connection' do
            expect(Docker::Container).to receive(:create).with(
              {
                'Image' => docker_container.image.image,
                'Env'   => JSON.parse(docker_container.env).each_with_object([]) { |item, obj| obj << item.join('=') },
                'Cmd'   => JSON.parse(docker_container.cmd),
                'Tty'   => true
              },
              docker_container.server.connection
            )
            subject
          end
        end
      end
    end
  end
end
