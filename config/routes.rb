Rails.application.routes.draw do
  # signup
  post 'signup', to: 'registrations#signup'
  
  # login
  post 'login', to: 'sessions#login'
  delete 'logout', to: 'sessions#logout'

  # events
  post 'events', to: "events#create"
  post 'events/:id/register', to: "events#register"
  get 'events', to: "events#index"
  get 'events/:id/get_registered_users', to: "events#get_registered_users"
  get 'events/:id/get_tickets', to: "events#get_tickets"
  get 'events/:id/get_winner', to: "events#get_winner"
  get 'events/get_all_winners', to: "events#get_all_winners"
end
