class Api::QuestionsController < Api::BaseController

	before_filter :authenticate_key
	require 'request_filter'

	def index
		@questions = Question.where('private = ?', false)
		if @questions.present?
			render json: { questions: @questions.as_json( root: false, 
																			only: [:id, :title, :private, :created_at, :updated_at],
																			include: { 
																									answers: { 
																															only: [:id, :body, :created_at, :updated_at],
																															include: {user: {only: [:id, :name]}}
																														} 
																								}
																		)
		}
		else
			render json: { error: "Couldn't find the questions" }, status: :not_found
		end
	end
	
	def show
	  @question = Question.where('id = ? AND private = ?', params[:id], false).first
	  if @question.present?
	  	render json: @question.as_json( root: true, 
	  																	only: [:id, :title, :created_at, :updated_at],
	  																	include: { 
	  																							answers: { 
	  																													only: [:id, :body, :created_at, :updated_at],
	  																													include: {user: {only: [:id, :name]}}
	  																												} 
	  																						}
	  																)
	  else
	  	render json: { error: "Couldn't find the question with id=#{params[:id]}" }, status: :not_found
	  end
	end

	private

		def question_params
			params.require(:questions).permit(:id, :title, :private, :user_id)
		end

		def has_valid_api_key?
			tenant = Tenant.find_by(api_key: request.headers['HTTP_X_API_KEY'])
			request_counter(tenant)
			return tenant.present?
		end

		def authenticate_key
			render json: { error: "401 Unauthorized - No valid API key provided" }, status: :forbidden unless has_valid_api_key?
		end

		def request_counter(tenant)
			day_count = tenant.day_requests + 1
      total_count = tenant.total_requests + 1
      tenant.update_columns(:day_requests => day_count, :total_requests => total_count)
		end

end
