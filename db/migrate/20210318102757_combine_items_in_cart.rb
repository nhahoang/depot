class CombineItemsInCart < ActiveRecord::Migration[5.2]
  def up
    LineItem.group(:product_id, :cart_id).sum(:quantity).each do |group_ids, quantity|
      next if quantity == 1
    
      product_id, cart_id = group_ids
      LineItem.where(product_id: product_id, cart_id: cart_id).destroy_all
      LineItem.create(product_id: product_id, cart_id: cart_id, quantity: quantity)
    end
  end

  def down
    LineItem.where("quantity > 1").each do |line_item|
      new_lines = []

      line_item.quantity.times do |new_line|
        new_lines << {
          product_id: line_item.product_id,
          cart_id: line_item.cart_id,
          quantity: 1
        }
      end

      LineItem.create(new_lines)
      line_item.destroy
    end
  end
end
