Rails.application.routes.draw do
  get 'welcome/index'  
  root 'welcome#index'

  namespace :api , defaults: {format: :json} do
    resources :questions, only: [:index, :show] 
  end

end
