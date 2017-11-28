Rails.application.routes.draw do
  root 'welcome#index'
  get 'index' =>'welcome#index'

  post 'index' => 'welcome#index'
  get 'welcome/test'

  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
