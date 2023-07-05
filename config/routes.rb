# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/docs'
  mount Rswag::Api::Engine => '/docs'
  
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index show create update destroy] do
        resources :mail_keys, only: %i[index] do
          get :sync, on: :collection
        end
        resources :mails, only: %i[show create]
      end
    end
  end
end
