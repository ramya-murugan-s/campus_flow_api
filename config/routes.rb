
Rails.application.routes.draw do
  devise_for :users, skip: [:sessions, :registrations]

  devise_scope :user do
    post "/api/v1/login",
         to: "campus_flow/api/v1/sessions#create"

    delete "/api/v1/logout",
           to: "campus_flow/api/v1/sessions#destroy"
  end

  get "/api/v1/students",
      to: "campus_flow/api/v1/students#index"

  post "/api/v1/students",
       to: "campus_flow/api/v1/students#create"

  get "/api/v1/students/:id",
      to: "campus_flow/api/v1/students#show"

  patch "/api/v1/students/:id",
        to: "campus_flow/api/v1/students#update"

  put "/api/v1/students/:id",
      to: "campus_flow/api/v1/students#update"

  delete "/api/v1/students/:id",
         to: "campus_flow/api/v1/students#destroy"

  post "/api/v1/teachers",
       to: "campus_flow/api/v1/teachers#create"
end
