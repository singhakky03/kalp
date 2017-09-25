class WelcomeController < ApplicationController
  def index
    @tenants = Tenant.all
    @questions = Question.includes(:user ,:answers)
  end
end
