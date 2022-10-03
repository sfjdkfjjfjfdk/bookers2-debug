Rails.application.routes.draw do
  get 'relationships/followings'
  get 'relationships/followers'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
# ネストさせる
  resources :users, only: [:index,:show,:edit,:update] do
    member do
      get :follows, :followers
    end
    resource :relationships, only: [:create, :destroy]
  end

  resources :books do
   resources :book_comments, only: [:create, :destroy]
   resource :favorites, only: [:create, :destroy]

  end
  root :to =>"homes#top"
  get "home/about"=>'homes#about', as: 'about'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

end