module Spree
  class Calculator::FlatPercentNthTaxonItem < Calculator
    preference :nth_item, :integer, :default => 2
    preference :taxon, :string, :default => ''
    preference :flat_percent, :decimal => 0.00

    def compute(order)
      result = 0.00

      if preferred_nth_item > 0
        prices = eligible_prices(order).sort { |a,b| b <=> a }

        segment_size = prices.length / preferred_nth_item

        last_segment_start = segment_size * (preferred_nth_item - 1)
        last_segment_stop = segment_size * preferred_nth_item - 1

        prices[last_segment_start..last_segment_stop].each do |price|
          result += (price * preferred_flat_percent / 100.0)
        end
      end

      result
    end

    def eligible_prices(order)
      result = []
      order.line_items.each do |line_item|
        if product_eligible?(line_item.product)
          line_item.quantity.times do
            result << line_item.price
          end
        end
      end
      result
    end

    def product_eligible?(product)
      product.taxons.where(:name => preferred_taxon).count > 0
    end
  end
end