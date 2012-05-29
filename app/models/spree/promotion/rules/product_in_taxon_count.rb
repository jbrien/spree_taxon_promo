module Spree
  class Promotion
    module Rules
      class ProductInTaxonCount < PromotionRule
        preference :count, :integer, :default => 2
        preference :taxon, :string, :default => ''
        preference :operator, :string, :default => 'gt'

        def eligible?(order, options = {})
          count = 0
          order.line_items.each do |line_item|
            if product_eligible?(line_item.product)
              count += line_item.quantity
            end
          end
          compare(count, preferred_count)
        end

        def compare(left, right)
          left.send(preferred_operator == 'gte' ? :>= : :>, right)
        end

        def product_eligible?(product)
          product.taxons.where(:name => preferred_taxon).count > 0
        end
      end
    end
  end
end