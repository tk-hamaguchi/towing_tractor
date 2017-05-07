require_dependency 'towing_tractor/application_controller'

module TowingTractor
  class Servers::ContainersController < ServersController
    before_action :set_container, only: %i(show destroy start stop logs status)

    def index
      @containers = DockerContainer.where(server_id: params[:server_id])
      render json: { containers: @containers }
    end

    def show
      render json: { container: @container }
    end

    def create
      @container = DockerContainer.create!(container_params)
      render json: { container: @container }, status: :created
    end

    def destroy
      @container.destroy
      render json: { container: @container }
    end

    def start
      @container.start
      render nothing: true, status: :accepted
    end

    def stop
      @container.stop
      render nothing: true, status: :accepted
    end

    def logs
      logs = @container.logs
      render json: { container: { id: @container.id, logs: logs } }
    end

    def status
    end

    private

    def set_container
      @container = docker_container
    end

    def docker_server
      @docer_server ||= DockerServer.find(
        params[:server_id]
      )
    end

    def docker_container
      @docker_container ||= DockerContainer.where(server_id: params[:server_id])
                                           .find(params[:id])
    end

    def container_params
      params.require(:container).permit(:image_id, :env, :cmd).merge(server_id: docker_server.id)
    end
  end
end
