module TowingTractor
  class DockerServer < ApplicationRecord
    has_many :containers, class_name: 'DockerContainer', foreign_key: 'server_id'

    validates :name,
      presence: true

    validates :url,
      uniqueness: true,
      format:     URI::regexp(%w(http https)),
      presence:   true

    validates :ca_cert,
      format:    /\A-----BEGIN CERTIFICATE-----\n.+-----END CERTIFICATE-----\n*\z/m,
      allow_nil: true

    validates :client_cert,
      format:    /\A-----BEGIN CERTIFICATE-----\n.+-----END CERTIFICATE-----\n*\z/m,
      allow_nil: true

    validates :client_key,
      format:    /\A-----BEGIN RSA PRIVATE KEY-----\n.+-----END RSA PRIVATE KEY-----\n*\z/m,
      allow_nil: true


    def connection
      @connection ||= begin
        opts = url =~ /^https/ ? ssl_option : {}
        Docker::Connection.new(url, opts)
      rescue => e
        raise e
      end
    end

    private

    def ssl_option
      cert_store  = OpenSSL::X509::Store.new
      certificate = OpenSSL::X509::Certificate.new(ca_cert)
      cert_store.add_cert certificate

      {
        client_cert_data: client_cert,
        client_key_data:  client_key,
        ssl_cert_store:   cert_store,
        scheme:           'https'
      }
    end
  end
end
