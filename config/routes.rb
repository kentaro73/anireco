Rails.application.routes.draw do
  root "posts#index"
  devise_for :users
  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create]
    get :search, on: :collection
  end
  resources :users
  # delete "/posts/:id/likes", to: "likes#destroy"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
