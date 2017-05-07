module TowingTractor
  class DockerContainer < ApplicationRecord
    belongs_to :server, class_name: 'DockerServer'
    belongs_to :image,  class_name: 'DockerImage'

    before_create  :create_container_to_docker_server
    before_destroy :delete_container_from_docker_server

    validates :image_id,
      presence: true

    validates :server_id,
      presence: true

    def container
      @container ||= begin
        raise ArgumentError.new('this is new record') unless container_id
        Docker::Container.get(container_id, {}, server.connection)
      rescue => e
        raise e
      end
    end

    def running?
      container.info['State']['Running']
    end

    def logs
      container.logs(stdout: true, stderr: true)
    end

    def start
      container.start
      self
    end

    def stop
      container.stop
      self
    end

    private

    def create_container_to_docker_server
      c_params = {
        'Image' => image.image,
        'Env'   => JSON.parse(self.env).each_with_object([]) { |item, obj| obj << item.join('=') },
        'Cmd'   => JSON.parse(cmd),
        'Tty'   => true
      }

      c = Docker::Container.create(
        c_params,
        server.connection
      )
      self.container_id = c.id
    end

    def delete_container_from_docker_server
      container.delete(force: true)
    end
  end
end
