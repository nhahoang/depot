require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def new_product(image_url)
    Product.new(
      title: "My Book Title",
      description: "yyy",
      price: 1,
      image_url: image_url
    )
  end

  test "product attributes must not be empty" do
    product = Product.new(
      title: "My Book Title",
      description: "yyy",
      image_url: "zzz.jpg"
    )

    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
    
    product.price = 1
    assert product.valid?
    assert product.errors[:title].blank?
    assert product.errors[:description].blank?
    assert product.errors[:price].blank?
    assert product.errors[:image_url].blank?
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg 
             http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end
end
