Rails.application.routes.draw do
  devise_for :users

  root "products#index"

  # 🛍 ТОВАРИ
  resources :products do
    member do
      delete "images/:image_id",
             to: "products#destroy_image",
             as: :destroy_image
    end

    # 💬 КОМЕНТАРІ ДО ТОВАРІВ
    resources :comments, only: [:create, :destroy]
  end

  # 🛒 КОРЗИНА
  resource :cart, controller: :carts, only: [:show] do
    post   "add/:product_id",    to: "carts#add",    as: :add
    patch  "update/:product_id", to: "carts#update", as: :update
    delete "remove/:product_id", to: "carts#remove", as: :remove
  end

  # 🧾 ЗАМОВЛЕННЯ
  resources :orders, only: [:new, :create, :show]

  # ✉ ЗВОРОТНІЙ ЗВʼЯЗОК (тільки залогінені)
  resources :feedbacks, only: [:new, :create]
end
