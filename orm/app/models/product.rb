class Product < ApplicationRecord
  self.table_name = 'products'
  self.primary_key = 'product_id'

  has_many :sales
  has_many :product_price_logs

  def self.with_average_sale_price(min_price, max_price, start_date, end_date)
    select(:product_id, :name, :kg_to_produce)
      .joins(:sales, :product_price_logs)
      .where(product_price_logs: { price: min_price..max_price })
      .where(sales: { datetime: start_date..end_date })
      .group(:product_id, :name, :kg_to_produce)
      .order(:product_id)
      .average('product_price_logs.price')
  end

end
