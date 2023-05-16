class ProductsController < ApplicationController
  def sale_price_with_weight
    @results = Product.with_average_sale_price(10, 100, '2023-01-01', '2023-12-31')
    render json: @results
  end

end
