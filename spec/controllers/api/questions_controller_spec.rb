require 'spec_helper'

describe Api::QuestionsController do
	before(:each) { request.headers['Accept'] = "application/json" }

	describe "GET #show" do
    before(:each) do
      @question = FactoryGirl.create :question
      get :show, question: @question.to_json, format: :json
    end

    it "don't show the private questions" do
      question_response = JSON.parse(response.body, symbolize_names: true)
      #expect(question_response[:title]).to eql @question.title
    end

    
  end
end