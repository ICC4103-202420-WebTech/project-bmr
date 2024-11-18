Rails.application.routes.draw do
  get "home/index"
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root 'home#index'

  # Nested resources for courses, lessons, questions, and answers
  resources :courses do
    resources :lessons do
      resources :questions, only: [:create, :destroy] do
        resources :answers, only: [:create, :destroy]
      end
    end
    resources :enrollments, only: [:create, :destroy]
    member do
      post 'enroll'
    end
  end

  # Route to show user's enrolled courses
  get 'my_courses', to: 'courses#my_courses', as: 'my_courses'
end
