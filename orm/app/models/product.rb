class Product < ApplicationRecord
  self.table_name = 'products'
  self.primary_key = 'product_id'

  has_many :sales
  has_many :product_price_logs
end
