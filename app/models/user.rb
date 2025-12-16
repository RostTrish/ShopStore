class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :products, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :feedbacks, dependent: :destroy

  before_validation :set_default_nickname, on: :create

  validates :nickname,
            presence: true,
            uniqueness: true,
            length: { minimum: 3, maximum: 30 }

  def admin?
    admin
  end

  private

  def set_default_nickname
    return if nickname.present?

    base = "User"
    number = User.maximum(:id).to_i + 1
    self.nickname = "#{base}##{number}"
  end
end
