module TowingTractor
  module ErrorHandler
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordNotFound,       with: :handle_not_found
      rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
      rescue_from ActiveRecord::StatementInvalid,     with: :handle_parameter_missing
      rescue_from ActiveRecord::RecordInvalid,        with: :handle_record_invalid
    end

    private

    def handle_not_found(e)
      render json: { error: e.message }, status: :not_found
    end

    def handle_record_invalid(e)
      render json: { error: e.record.errors }, status: :unprocessable_entity
    end

    def handle_parameter_missing(e)
      render json: { error: e.message }, status: :unprocessable_entity
    end

  end
end
