class Product < ApplicationRecord
  # 🔗 АВТОР ТОВАРУ
  belongs_to :user

  # 🖼 ЗОБРАЖЕННЯ
  has_many_attached :images

  has_many :comments, dependent: :destroy


  # ⚙️ ХАРАКТЕРИСТИКИ
  has_many :product_properties, dependent: :destroy
  accepts_nested_attributes_for :product_properties,
                                allow_destroy: true,
                                reject_if: :all_blank

  # ✅ ВАЛІДАЦІЇ
  validates :name, presence: true
  validates :price,
            presence: true,
            numericality: { greater_than: 0 }
  validates :user, presence: true

  validate :acceptable_images

  # 🔍 SCOPES ДЛЯ КАТАЛОГУ
  scope :search_by_name, ->(query) {
    where("name ILIKE ?", "%#{query}%") if query.present?
  }

  scope :order_by_price, ->(order) {
    case order
    when "asc"  then order(price: :asc)
    when "desc" then order(price: :desc)
    else all
    end
  }

  private

  def acceptable_images
    return unless images.attached?

    images.each do |image|
      unless image.content_type.in?(%w[image/png image/jpg image/jpeg])
        errors.add(:images, "повинні бути зображеннями (PNG або JPG)")
      end

      if image.byte_size > 5.megabytes
        errors.add(:images, "одне з фото занадто велике (макс. 5 MB)")
      end
    end
  end
end
