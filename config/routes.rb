TowingTractor::Engine.routes.draw do
  resources :images,  defaults: { format: :json }
  resources :servers, defaults: { format: :json } do
    resources :containers, module: 'servers'
  end
end
