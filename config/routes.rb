Rails.application.routes.draw do
  get 'welcome/index'  
  root 'welcome#index'

  namespace :api do
    resources :questions, only: [:show] 
  end

end
