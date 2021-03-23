class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product)
    current_item = line_items.find_by(product_id: product.id)
    
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(product_id: product.id)
    end

    current_item
  end

  def total_price
    sum_price = 0

    self.line_items.each do |line_item|
      sum_price += line_item.total_price
    end
    
    sum_price
  end
end