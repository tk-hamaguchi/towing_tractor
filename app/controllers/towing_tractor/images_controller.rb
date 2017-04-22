require_dependency 'towing_tractor/application_controller'

module TowingTractor
  class ImagesController < ApplicationController
    before_action :set_image, only: %i(show update destroy)

    def index
      @images = DockerImage.all
      render json: { images: @images }
    end

    def create
      @image = DockerImage.create!(image_params)
      render json: { image: @image }, status: :created
    end

    def show
      render json: { image: @image }
    end

    def update
      @image.update!(image_params)
      render json: { image: @image }
    end

    def destroy
      @image.destroy!
      render json: { image: @image }
    end

    private

    def set_image
      @image = DockerImage.find(params[:id])
    end

    def image_params
      params.require(:image).permit(:name, :image)
    end
  end
end
