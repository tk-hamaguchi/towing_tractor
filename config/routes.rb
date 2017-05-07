TowingTractor::Engine.routes.draw do
  resources :images,  defaults: { format: :json }
  resources :servers, defaults: { format: :json } do
    resources :containers, module: 'servers', only: %i(index create show destroy) do
      member do
        put :start
        put :stop
        get :logs
        get :status
      end
    end
  end
end
