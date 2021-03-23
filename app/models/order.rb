class Order < ApplicationRecord

  # Define pay type when checkout cart
  enum pay_type: {
    "Check" => 0,
    "Credit card" => 1,
    "Purchase order" => 2
  }

  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: pay_types.keys

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end