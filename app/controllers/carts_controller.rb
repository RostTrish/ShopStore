class CartsController < ApplicationController

  def show
    @cart_items = Product.find(session[:cart].keys)
  end

  def add
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1

    session[:cart][product_id] = (session[:cart][product_id] || 0) + quantity

    redirect_back fallback_location: products_path,
                  notice: "Товар додано до корзини"
  end

  def update
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i

    if quantity > 0
      session[:cart][product_id] = quantity
    else
      session[:cart].delete(product_id)
    end

    redirect_to cart_path
  end

  def remove
    session[:cart].delete(params[:product_id].to_s)
    redirect_to cart_path, notice: "Товар видалено з корзини"
  end
end
