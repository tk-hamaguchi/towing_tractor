FactoryGirl.define do
  factory :docker_server, class: 'TowingTractor::DockerServer' do
    name { Faker::Pokemon.name }
    url  { Faker::Internet.url }
  end

  factory :docker_tls_server, class: 'TowingTractor::DockerServer' do
    name { Faker::Pokemon.name }
    url  { Faker::Internet.url(Faker::Internet.domain_name ,nil ,'https') << ":#{Random.rand(2_000 .. 6_000)}/" }
    after(:build) { |server|
      # CA
      digest = OpenSSL::Digest::SHA1.new
      issu   = OpenSSL::X509::Name.new
      pkey   = OpenSSL::PKey::RSA.new(2048)

      ca_key  = pkey.export

      # CA-Cert
      issu_cer = OpenSSL::X509::Certificate.new
      issu_cer.not_before = Time.now
      issu_cer.not_after  = Time.now + 1*365*24*60*60
      issu_cer.public_key = pkey.public_key
      issu_cer.serial  = 1
      issu_cer.issuer  = issu
      issu_cer.subject = issu
      ex = OpenSSL::X509::Extension.new(
        'basicConstraints',
        OpenSSL::ASN1.Sequence([OpenSSL::ASN1::Boolean(true)])
      )
      issu_cer.add_extension ex
      issu_cer.sign pkey, digest

      docker_ca = issu_cer.to_pem

      ## Client
      sub = OpenSSL::X509::Name.new
      sub_rsa = OpenSSL::PKey::RSA.generate 2048
      digest = OpenSSL::Digest::SHA1.new

      docker_key = sub_rsa.export

      ## Client-Cert
      sub_cer = OpenSSL::X509::Certificate.new
      sub_cer.not_before = Time.now
      sub_cer.not_after  = Time.now + 1*365*24*60*60
      sub_cer.public_key = sub_rsa.public_key
      sub_cer.serial  = (Time.now.to_f * (10 ^ 3)).to_i
      sub_cer.issuer  = issu
      sub_cer.subject = sub
      sub_cer.sign pkey, digest

      docker_cert = sub_cer.to_pem

      ###

      server.ca_cert     = docker_ca
      server.client_cert = docker_cert
      server.client_key  = docker_key
    }
  end
end
