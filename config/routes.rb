Rails.application.routes.draw do
  # resource :session
  # resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
        post "/users/sign_up", to: "users/registrations#create"
        post "/users/sign_in", to: "users/sessions#create"
        delete "/users/sign_out", to: "users/sessions#destroy"

        post "/admins/sign_up", to: "admins/registrations#create"
        post "/admins/sign_in", to: "admins/sessions#create"
        delete "/admins/sign_out", to: "admins/sessions#destroy"

        namespace :admins do
          resources :activities, except: :show
          resources :programs, except: :index do
            resources :program_activities
          end
        end
    end
  end

  get "/test", to: "test#index"
end
