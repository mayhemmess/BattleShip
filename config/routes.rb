require 'api_constraints'

Rails.application.routes.draw do
namespace :api, defaults: {format: :json},
constraints: { subdomain: 'api'}, path: '/' do
	scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
  get 'sessions/new'

get 'home'  => 'static_pages#home'
get 'help'    => 'static_pages#help'
get 'signup'  => 'users#new'
get    'login'   => 'sessions#new'
post   'login'   => 'sessions#create'
delete 'logout'  => 'sessions#destroy'
  get '/chat' => 'chat#chat'
 root to: 'chat#index'



resources :users  

end
end
end