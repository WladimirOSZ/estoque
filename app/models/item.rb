class Item < ApplicationRecord
  has_many :item_categories
  has_many :categories, through: :item_categories
  has_many :item_lot
  has_many :lots, through: :item_lot
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  has_one_attached :photo

  validates :name, :description, :photo, :weight, :width, :height, :depth, presence: true
  validates :weight, :width, :height, :depth, numericality: { greater_than: 0 }
  validates :description, length: { minimum: 100 }


  accepts_nested_attributes_for :categories

  before_validation :generate_code

  def self.avaliable
    unavaliable_items = ItemLot.avaliable.pluck(:item_id)
    @items = Item.where.not(id: unavaliable_items)
  end

  private
  def generate_code
    self.code = SecureRandom.alphanumeric(10)
  end

end
