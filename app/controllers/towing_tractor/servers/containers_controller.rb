require_dependency 'towing_tractor/application_controller'

module TowingTractor
  class Servers::ContainersController < ServersController
    def index
      @containers = DockerContainer.where(server_id: params[:server_id])
      render json: { containers: @containers }
    end

    def show
      @container = docker_container
      render json: { container: @container }
    end

    def create
      @container = DockerContainer.create!(container_params)
      render json: { container: @container }, status: :created
    end

    def destroy
      @container = docker_container
      @container.destroy
      render json: { container: @container }
    end

    private

    def docker_server
      @docer_server ||= DockerServer.find(
        params[:server_id]
      )
    end

    def docker_container
      @docker_container ||= DockerContainer.find(
        params[:id],
        condition: { server_id: params[:server_id] }
      )
    end

    def container_params
      params.require(:container).permit(:image_id, :env, :cmd).merge(server_id: docker_server.id)
    end
  end
end
