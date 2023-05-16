class ItemLot < ApplicationRecord
  belongs_to :lot
  belongs_to :item

  validates :item_id, uniqueness: true
  
end
