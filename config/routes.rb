Rails.application.routes.draw do
  root to: "players#index"
  delete '/logout', to: 'users#delete'
  get 'auth/:provider/callback', to: 'users#create'
  get 'auth/failure', to: redirect('/')
  resources :players, except: [:show, :index]
  get '/admin', to: 'admin#index', as: 'admin'
  get '/admin/logs', to: 'admin#logs', as: 'admin_logs'
  get '/admin/users', to: 'admin#users', as: 'admin_users'
  get '/admin/users/:id/modification', to: 'admin#edit_user', as: 'admin_edit_user'
  resources :users, only: %i[edit update]

end
