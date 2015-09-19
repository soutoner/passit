Rails.application.routes.draw do
  root 'static_pages#index'

  devise_for :users, controllers: {
                       sessions:      'users/sessions'
                   }, skip: [:registrations]
  as :user do
    post '/users' => 'users/registrations#create', :as => :user_registration
    get '/users/sign_up' => 'users/registrations#new', :as => :new_user_registration
    get '/users/edit' => 'users/registrations#edit', :as => :edit_user_registration
    patch '/users/' => 'users/registrations#update'
    put '/users/update/profile' => 'users/registrations#update_profile'
    put '/users/update/password' => 'users/registrations#update_password'
    delete '/users/' => 'users/registrations#destroy'
    delete '/users/avatar' => 'users/registrations#destroy_avatar', :as => :destroy_user_avatar
  end

  # Follow relationship
  authenticate :user do
    post '/users/follow' => 'follow_relationship#create', :as => :follow_user
    delete '/users/follow' => 'follow_relationship#destroy', :as => :unfollow_user
  end
  resources :users, only: [:index, :show], param: :username
end
