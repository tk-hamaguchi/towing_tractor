module TowingTractor
  class ApplicationController < ActionController::API
    include TowingTractor::ErrorHandler

    # protect_from_forgery with: :exception
  end
end
