class FeedbacksController < ApplicationController
  before_action :authenticate_user!

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = current_user.feedbacks.build(feedback_params)

    if @feedback.save
      redirect_to root_path, notice: "Дякуємо за ваш відгук!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:message)
  end
end
