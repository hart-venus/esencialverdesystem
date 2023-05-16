class ProductPriceLog < ApplicationRecord
  self.table_name = 'product_price_log'
  self.primary_key = 'product_price_log_id'

  belongs_to :product
end
