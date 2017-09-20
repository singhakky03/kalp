class Api::QuestionsController < ApplicationController

	before_filter :authenticate_key
	
	def show
	  @question = Question.find(params[:id])
	  render json: @question.to_json
	end

	private

		def question_params
			params.require(:questions).permit(:id, :title, :private, :user_id)
		end

		def has_valid_api_key?
			key = Tenant.find_by(api_key: request.headers['HTTP_X_API_KEY'])
			return key.present?
		end

		def authenticate_key
			return head :forbidden unless has_valid_api_key?
		end

end
