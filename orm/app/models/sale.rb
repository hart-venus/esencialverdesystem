class Sale < ApplicationRecord
  self.table_name = 'sales'
  self.primary_key = 'sale_id'


  belongs_to :product
end
