require 'rails_helper'

module TowingTractor
  RSpec.describe DockerServer, type: :model do
    subject { FactoryGirl.build(:docker_server) }

    context 'relation' do
      it { is_expected.to have_many :containers }
    end

    context '#to_json' do
      subject { super().to_json }

      it 'should eq valid JSON format' do
        expect{JSON.parse(subject)}.to_not raise_error
      end
      context 'parsed' do
        subject { JSON.parse(super()) }
        it { is_expected.to have_key('id') }
        it { is_expected.to have_key('name') }
        it { is_expected.to have_key('url') }
        it { is_expected.to have_key('ca_cert') }
        it { is_expected.to have_key('client_cert') }
        it { is_expected.to have_key('client_key') }
        it { is_expected.to have_key('created_at') }
        it { is_expected.to have_key('updated_at') }
      end
    end

    context ':name' do
      it { is_expected.to validate_presence_of(:name) }
    end

    context ':url' do
      it { is_expected.to validate_presence_of(:url) }
      it { is_expected.to validate_uniqueness_of(:url) }
      it { is_expected.to allow_value('http://localhost:2375').for(:url) }
      it { is_expected.to allow_value('https://example.com').for(:url) }
      it { is_expected.to allow_value('http://192.168.1.1:8080/').for(:url) }
      it { is_expected.to_not allow_value('localhost:2375').for(:url) }
      it { is_expected.to_not allow_value('//example.com').for(:url) }
      it { is_expected.to_not allow_value('unix:/tmp/hoge.sock').for(:url) }
    end

    context ':ca_cert' do
      it { is_expected.to allow_value(nil).for(:ca_cert) }
      it { is_expected.to allow_value("-----BEGIN CERTIFICATE-----\nMIICdDCCAVwCAQMwDQYJKoZIhvcNAQEFBQAwADAeFw0xNzA1MDYwMjU2NTFaFw0x\nTuxWGiQ2YQM=\n-----END CERTIFICATE-----\n").for(:ca_cert) }
      it { is_expected.to_not allow_value('').for(:ca_cert) }
      it { is_expected.to_not allow_value('aaa').for(:ca_cert) }
      it { is_expected.to_not allow_value("-----BEGIN RSA PRIVATE KEY-----\nMIIEpQIBAAKCAQEAtVkc4GtmupvBDXtmkHcfezATa1a25bvtmOnKGuT/E0a1KoAU\nGoaGlgVN1h9iydx/s8Y4SOhKU86SuG0W03MgJogjlSE4Dg/ExnuA/Jw=\n-----END RSA PRIVATE KEY-----\n").for(:ca_cert) }
    end

    context ':client_cert' do
      it { is_expected.to allow_value(nil).for(:client_cert) }
      it { is_expected.to allow_value("-----BEGIN CERTIFICATE-----\nMIICdDCCAVwCAQMwDQYJKoZIhvcNAQEFBQAwADAeFw0xNzA1MDYwMjU2NTFaFw0x\nTuxWGiQ2YQM=\n-----END CERTIFICATE-----\n").for(:client_cert) }
      it { is_expected.to_not allow_value('').for(:client_cert) }
      it { is_expected.to_not allow_value('aaa').for(:client_cert) }
      it { is_expected.to_not allow_value("-----BEGIN RSA PRIVATE KEY-----\nMIIEpQIBAAKCAQEAtVkc4GtmupvBDXtmkHcfezATa1a25bvtmOnKGuT/E0a1KoAU\nGoaGlgVN1h9iydx/s8Y4SOhKU86SuG0W03MgJogjlSE4Dg/ExnuA/Jw=\n-----END RSA PRIVATE KEY-----\n").for(:client_cert) }
    end

    context ':client_key' do
      it { is_expected.to allow_value(nil).for(:client_key) }
      it { is_expected.to allow_value("-----BEGIN RSA PRIVATE KEY-----\nMIIEpQIBAAKCAQEAtVkc4GtmupvBDXtmkHcfezATa1a25bvtmOnKGuT/E0a1KoAU\nGoaGlgVN1h9iydx/s8Y4SOhKU86SuG0W03MgJogjlSE4Dg/ExnuA/Jw=\n-----END RSA PRIVATE KEY-----\n").for(:client_key) }
      it { is_expected.to_not allow_value('').for(:client_key) }
      it { is_expected.to_not allow_value('aaa').for(:client_key) }
      it { is_expected.to_not allow_value("-----BEGIN CERTIFICATE-----\nMIICdDCCAVwCAQMwDQYJKoZIhvcNAQEFBQAwADAeFw0xNzA1MDYwMjU2NTFaFw0x\nTuxWGiQ2YQM=\n-----END CERTIFICATE-----\n").for(:client_key) }
    end

    context '#connection' do
      subject { server.connection }
      let(:conn) { double(Docker::Connection) }
      let(:xstore) { double(OpenSSL::X509::Store, add_cert: true) }
      let(:xcert)  { double(OpenSSL::X509::Certificate) }
      let(:server) { FactoryGirl.build(:docker_server) }
      let(:error) { RuntimeError.new }
      before do
        server
        allow(Docker::Connection).to receive(:new).and_return(conn)
        allow(OpenSSL::X509::Store).to receive(:new).and_return(xstore)
        allow(OpenSSL::X509::Certificate).to receive(:new).and_return(xcert)
      end
      it 'should eq expected instance of Docker::Connection' do
        is_expected.to eq conn
      end
      context 'if Docker::Connection was raise error' do
        before do
          allow(Docker::Connection).to receive(:new).and_raise(error)
        end
        it 'should throw raise error' do
          expect{subject}.to raise_error(error)
        end
      end
      context 'with http url' do
        it 'Docker::Connection should receive :new with url and {}' do
          expect(Docker::Connection).to receive(:new).with(server.url, {})
          subject
        end
      end
      context 'with https url' do
        let(:server) { FactoryGirl.build(:docker_tls_server) }
        it 'Docker::Connection should receive :new with url and ssl_option' do
          expect(Docker::Connection).to receive(:new).with(server.url, {
            client_cert_data: server.client_cert,
            client_key_data:  server.client_key,
            ssl_cert_store:   xstore,
            scheme:           'https'
          })
          subject
        end
      end
    end
  end
end
