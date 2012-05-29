require 'spec_helper'

describe Spree::Calculator::FlatPercentNthTaxonItem do
  let(:order) { mock_model(Spree::Order, :user => nil) }

  let(:calculator) { Spree::Calculator::FlatPercentNthTaxonItem.new } 
  let(:taxon) { 'Sample Taxon' }

  before do
    calculator.preferred_nth_item = 2
    calculator.preferred_taxon = taxon
    calculator.preferred_flat_percent = 50.0
  end

  it "correctly calculates nth item discount" do
    line_items = [
      mock_model(Spree::LineItem, :quantity => 1, :price => 35.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 25.00, :product => mock_model(Spree::Product))
    ]

    line_items.each do |line_item|
      calculator.should_receive(:product_eligible?).
        with(line_item.product).
        and_return(true)
    end

    order.stub :line_items => line_items

    calculator.compute(order).should == 12.50
  end

  it "uses the price of the cheaper item, if there are two with different prices" do
    line_items = [
      mock_model(Spree::LineItem, :quantity => 1, :price => 25.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 35.00, :product => mock_model(Spree::Product))
    ]

    line_items.each do |line_item|
      calculator.should_receive(:product_eligible?).
        with(line_item.product).
        and_return(true)
    end

    order.stub :line_items => line_items

    calculator.compute(order).should == 12.50
  end

  it "repeats the discount if there are enough items in the cart" do
    line_items = [
      mock_model(Spree::LineItem, :quantity => 1, :price => 25.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 35.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 25.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 35.00, :product => mock_model(Spree::Product))
    ]

    line_items.each do |line_item|
      calculator.should_receive(:product_eligible?).
        with(line_item.product).
        and_return(true)
    end

    order.stub :line_items => line_items

    calculator.compute(order).should == 25.00
  end

  it "still works when there's a 'left over' item in the cart" do
    line_items = [
      mock_model(Spree::LineItem, :quantity => 1, :price => 25.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 35.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 25.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 35.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 12.00, :product => mock_model(Spree::Product))
    ]

    line_items.each do |line_item|
      calculator.should_receive(:product_eligible?).
        with(line_item.product).
        and_return(true)
    end

    order.stub :line_items => line_items

    calculator.compute(order).should == 25.00
  end

  it "returns 0 when no products belong to the taxon" do
    line_items = [
      mock_model(Spree::LineItem, :quantity => 1, :price => 25.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 35.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 25.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 35.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 12.00, :product => mock_model(Spree::Product))
    ]

    line_items.each do |line_item|
      calculator.should_receive(:product_eligible?).
        with(line_item.product).
        and_return(false)
    end

    order.stub :line_items => line_items

    calculator.compute(order).should == 0.00
  end

  it "ignores products that don't belong to the taxon" do
    line_items = [
      mock_model(Spree::LineItem, :quantity => 1, :price => 25.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 35.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 25.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 35.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 12.00, :product => mock_model(Spree::Product))
    ]

    line_items.each_with_index do |line_item, index|
      calculator.should_receive(:product_eligible?).
        with(line_item.product).
        and_return(index < 1)
    end

    order.stub :line_items => line_items

    calculator.compute(order).should == 12.50
  end

  it "return 0 when nth_item is set to 0" do
    calculator.preferred_nth_item = 0

    line_items = [
      mock_model(Spree::LineItem, :quantity => 1, :price => 25.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 35.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 25.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 35.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 12.00, :product => mock_model(Spree::Product))
    ]

    order.stub :line_items => line_items

    calculator.compute(order).should == 0.00
  end

  it "correctly counts multiple quanties" do
    line_items = [
      mock_model(Spree::LineItem, :quantity => 2, :price => 25.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 2, :price => 35.00, :product => mock_model(Spree::Product)),
      mock_model(Spree::LineItem, :quantity => 1, :price => 12.00, :product => mock_model(Spree::Product))
    ]

    line_items.each do |line_item|
      calculator.should_receive(:product_eligible?).
        with(line_item.product).
        and_return(true)
    end

    order.stub :line_items => line_items

    calculator.compute(order).should == 25.00
  end
end
