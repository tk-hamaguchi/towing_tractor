module TowingTractor
  class DockerServer < ApplicationRecord
    validates :name,
      presence: true

    validates :url,
      uniqueness: true,
      format:     URI::regexp(%w(http https)),
      presence:   true

    def connection
      @connection ||= begin
        opts = {}
        if url =~ /^https/
          cert_store  = OpenSSL::X509::Store.new
          certificate = OpenSSL::X509::Certificate.new ENV["DOCKER_CA"]
          cert_store.add_cert certificate

          opts = {
            client_cert_data: ENV["DOCKER_CERT"],
            client_key_data:  ENV["DOCKER_KEY"],
            ssl_cert_store:   cert_store,
            scheme: 'https'
          }
        end
        Docker::Connection.new(url, opts)
      rescue => e
        raise e
      end
    end
  end
end
