Rails.application.routes.draw do
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
