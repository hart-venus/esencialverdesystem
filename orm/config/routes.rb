Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/people', to: 'people#index'
  get '/products/sale_price_with_weight', to: 'products#sale_price_with_weight'

  # Defines the root path route ("/")
  # root "articles#index"
end
