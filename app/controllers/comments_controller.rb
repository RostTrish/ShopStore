class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_product
  before_action :set_comment, only: :destroy

  def create
    @comment = @product.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @product, notice: "Коментар додано"
    else
      redirect_to @product, alert: "Коментар не може бути порожнім"
    end
  end

  def destroy
    unless @comment.user == current_user || current_user.admin?
      redirect_to @product, alert: "Немає доступу"
      return
    end

    @comment.destroy
    redirect_to @product, notice: "Коментар видалено"
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_comment
    @comment = @product.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
