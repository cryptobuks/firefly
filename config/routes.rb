Rails.application.routes.draw do
  resources :teams

  require 'sidekiq/web'

  resources :observers

  devise_for :users, :path => '', :path_names => { :sign_in => "signin", :sign_out => "logout", :sign_up => "registration" }, :controllers => { :registrations => "registrations" }

  get 'dashboard' => 'dashboard#welcome'
  get 'hacker/:id' => 'dashboard#profile', :as => 'hacker_profile'

  get 'rules' => 'page#rules'
  get 'land' => 'page#land'

  namespace :api, :path => "api", :defaults => {:format => :json} do
    namespace :v1 do
      get 'validate/observer' => 'validate#observer'
      get 'qrcode/generate' => 'qrcode#generate'
      get 'attendees/checkin' => 'attendees#check_in'
      post 'process/cameratag' => 'process#cameratag'
    end
  end

  namespace :admin, :path => "admin" do
    get 'hackers' => 'admin#hackers'
    get 'observers' => 'admin#observers'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  root 'page#home'

  mount Sidekiq::Web, at: '/sidekiq'

end
