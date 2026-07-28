Rails.application.routes.draw do
  get '/' => 'static_pages#admin_console', :constraints => { :subdomain => 'console' }, as: :admin_root
  get '/' => 'static_pages#renter_console', :constraints => { :subdomain => 'admin' }, as: :renter_root
  root "static_pages#home"

  devise_for :customers, path: 'customers', skip: [:registrations, :sessions], controllers: {
    confirmations: 'customers/confirmations',
    passwords: 'customers/passwords',
    registrations: 'customers/registrations',
    sessions: 'customers/sessions',
    unlocks: 'customers/unlocks'
  }

  devise_scope :customer do
    put    '/customer_profile',  to: 'customers/registrations#update'
    delete '/customer_profile',  to: 'customers/registrations#destroy'
    post   '/customer_profile',  to: 'customers/registrations#create'
    get    '/customer_register', to: 'customers/registrations#new',    as: :new_customer_registration
    get    '/customer_profile',  to: 'customers/registrations#edit',   as: :edit_customer_registration
    patch  '/customer_profile',  to: 'customers/registrations#update', as: :customer_registration
    get    '/customer_profile/cancel', to: 'customers/registrations#cancel', as: :cancel_customer_registration
    get 'customer_login', to: 'customers/sessions#new', as: :new_customer_session
    post 'customer_login', to: 'customers/sessions#create', as: :customer_session
    delete 'customer_logout', to: 'customers/sessions#destroy', as: :destroy_customer_session
  end

  constraints subdomain: 'console' do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
    devise_for :admins, path: 'admins', skip: [:registrations, :sessions], controllers: {
      confirmations: 'admins/confirmations',
      passwords: 'admins/passwords',
      registrations: 'admins/registrations',
      sessions: 'admins/sessions',
      unlocks: 'admins/unlocks'
    }

    devise_scope :admin do
      put    '/admin_profile',  to: 'admins/registrations#update'
      delete '/admin_profile',  to: 'admins/registrations#destroy'
      post   '/admin_profile',  to: 'admins/registrations#create'
      get    '/admin_register', to: 'admins/registrations#new',    as: :new_admin_registration
      get    '/admin_profile',  to: 'admins/registrations#edit',   as: :edit_admin_registration
      patch  '/admin_profile',  to: 'admins/registrations#update', as: :admin_registration
      get    '/admin_profile/cancel', to: 'admins/registrations#cancel', as: :cancel_admin_registration
      get 'admin_login', to: 'admins/sessions#new', as: :new_admin_session
      post 'admin_login', to: 'admins/sessions#create', as: :admin_session
      delete 'admin_logout', to: 'admins/sessions#destroy', as: :destroy_admin_session
    end
  end

  constraints subdomain: 'admin' do
    resources :companies, except: [:index]
    resources :vehicles, except: [:index, :new, :edit, :update] do
      resources :build, only: [:show, :update], controller: 'vehicles/build'
    end
    devise_for :renters, path: 'renters', skip: [:registrations, :sessions], controllers: {
      confirmations: 'renters/confirmations',
      passwords: 'renters/passwords',
      registrations: 'renters/registrations',
      sessions: 'renters/sessions',
      unlocks: 'renters/unlocks'
    }

    devise_scope :renter do
      put    '/renter_profile',  to: 'renters/registrations#update'
      delete '/renter_profile',  to: 'renters/registrations#destroy'
      post   '/renter_profile',  to: 'renters/registrations#create'
      get    '/renter_register', to: 'renters/registrations#new',    as: :new_renter_registration
      get    '/renter_profile',  to: 'renters/registrations#edit',   as: :edit_renter_registration
      patch  '/renter_profile',  to: 'renters/registrations#update', as: :renter_registration
      get    '/renter_profile/cancel', to: 'renters/registrations#cancel', as: :cancel_renter_registration
      get 'renter_login', to: 'renters/sessions#new', as: :new_renter_session
      post  'renter_login', to: 'renters/sessions#create', as: :renter_session
      delete 'renter_logout', to: 'renters/sessions#destroy', as: :destroy_renter_session 
    end
  end
end
