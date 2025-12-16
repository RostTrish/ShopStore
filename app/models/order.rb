class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum :payment_method, {
    cash_on_delivery: 0,
    card: 1
  }

  enum :delivery_method, {
    nova_poshta: 0,
    ukrposhta: 1,
    pickup: 2
  }

  enum :status, {
    new_order: 0,
    paid: 1,
    shipped: 2
  }

  validates :payment_method, presence: true
  validates :delivery_method, presence: true
  validates :status, presence: true
end
