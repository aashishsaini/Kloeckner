Rails.application.routes.draw do
  resources :products, only: [:index] do
    collection do
      post :import_csv
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'products#index'
end
