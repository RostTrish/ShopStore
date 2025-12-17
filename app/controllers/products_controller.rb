class ProductsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_product, only: %i[
    show edit update destroy destroy_image
  ]

  def index
    @products = Product.all
    @products = @products.search_by_name(params[:q])
    @products = @products.order_by_price(params[:price])
  end

  def show; end

  def new
    @product = Product.new
    @product.product_properties.build
  end

  def create
    @product = current_user.products.build(product_params) # ✅ КЛЮЧОВИЙ РЯДОК

    if @product.save
      redirect_to @product, notice: "Товар успішно створено."
    else
      @product.product_properties.build if @product.product_properties.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product.product_properties.build
  end

  def update
    new_images = product_params[:images]

    if @product.update(product_params.except(:images))
      @product.images.attach(new_images) if new_images.present?
      redirect_to edit_product_path(@product), notice: "Товар оновлено."
    else
      @product.product_properties.build
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Товар видалено."
  end

  def destroy_image
    image = @product.images.find(params[:image_id])
    image.purge
    redirect_to edit_product_path(@product), notice: "Фото видалено."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :price,
      images: [],
      product_properties_attributes: %i[id name value _destroy]
    )
  end
end
