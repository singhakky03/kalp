class Api::QuestionsController < Api::BaseController

	before_filter :authenticate_key
	
	def show
	  @question = Question.where('id = ? AND private = ?', params[:id], false).first
	  if @question.present?

	  	render json: @question.to_json
	  else
	  	render json: { error: "Couldn't find the question with id=#{params[:id]}" }, status: :not_found
	  end
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
