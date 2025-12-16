class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    if session[:cart].blank?
      redirect_to cart_path, alert: "Корзина порожня"
      return
    end

    @order = Order.new
    @cart_items = Product.where(id: session[:cart].keys)
  end

  def create
    if session[:cart].blank?
      redirect_to cart_path, alert: "Корзина порожня"
      return
    end

    @order = current_user.orders.build(order_params)
    @order.status = :new_order

    total = 0

    session[:cart].each do |product_id, quantity|
      product = Product.find(product_id)
      @order.order_items.build(
        product: product,
        quantity: quantity,
        price: product.price
      )
      total += product.price * quantity
    end

    @order.total = total

    if @order.save
      session[:cart] = {}
      redirect_to @order, notice: "Замовлення створено"
    else
      @cart_items = Product.where(id: session[:cart].keys)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:delivery_method, :payment_method)
  end
end
