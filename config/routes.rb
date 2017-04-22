TowingTractor::Engine.routes.draw do
  resources :images,  defaults: { format: :json }
  resources :servers, defaults: { format: :json }
end
