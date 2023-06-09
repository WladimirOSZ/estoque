class ItemLot < ApplicationRecord
  belongs_to :lot
  belongs_to :item

  enum canceled: { canceled: true, avaliable: false }

  validates :item_id, :lot_id, presence: true

  validate :item_cant_be_in_an_active_lot

  def item_cant_be_in_an_active_lot
    if item_id.present? && ItemLot.where(item_id: item_id).avaliable.any?
      errors.add(:item_id, "não pode estar em outro lote ativo")
    end
  end

  
end
