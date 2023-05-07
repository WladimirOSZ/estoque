class Item < ApplicationRecord
  has_many :item_categories
  has_many :categories, through: :item_categories

  accepts_nested_attributes_for :categories

  before_validation :generate_code

  private
  def generate_code
    self.code = SecureRandom.alphanumeric(10)
  end

end
