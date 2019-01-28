require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  test "should not save product without part_number" do
    product = Product.new
    assert_not product.save
  end

  test "should save product with part_number" do
    product = Product.new(part_number: 'ID101034')
    assert product.save
  end

  test "parse the csv and return the collection of rows" do
    all_rows = Product.extract_rows(Rails.root.join('data.csv'))
    assert_kind_of(Array, all_rows)
  end

  test "should return true for valid CSV" do
    response = Product.process_csv(Rails.root.join('data.csv'), ',', 'false')
    assert_not response
  end
end
