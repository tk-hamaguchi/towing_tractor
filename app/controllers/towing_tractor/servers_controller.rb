require_dependency 'towing_tractor/application_controller'

module TowingTractor
  class ServersController < ApplicationController
    before_action :set_server, only: %i(show update destroy)

    def index
      @servers = DockerServer.all
      render json: @servers
    end

    def show
      render json: { server: @server }
    end

    def create
      @server = DockerServer.create!(server_params)
      render json: { server: @server }, status: :created
    end

    def update
      @server.update!(server_params)
      render json: { server: @server }
    end

    def destroy
      @server.destroy!
      render json: { server: @server }
    end

    private

    def set_server
      @server = DockerServer.find(params[:id])
    end

    def server_params
      params.require(:server).permit(:name, :url)
    end
  end
end
