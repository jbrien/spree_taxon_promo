require 'spec_helper'

describe Spree::Promotion::Rules::ProductInTaxonCount do
  let(:rule) { Spree::Promotion::Rules::ProductInTaxonCount.new }
  let(:order) { mock_model(Spree::Order, :user => nil) }
  let(:taxon) { 'Sample Taxon' }
  let(:line_items) { line_items = Array.new(5) { mock_model(Spree::LineItem, :quantity => 1, :product => mock_model(Spree::Product)) } }

  before do 
    rule.preferred_count = 2
    rule.preferred_taxon = taxon
  end

  context 'preferred operator set to gt' do
    before { rule.preferred_operator = 'gt' }

    it 'should be eligible when number of products in taxon is greater than perferred count' do      
      line_items.each do |line_item|
        rule.should_receive(:product_eligible?).
          with(line_item.product).
          and_return(true)
      end
      order.stub :line_items => line_items
      rule.should be_eligible(order)
    end

    it 'should not be eligible when number of products in taxon is equal to the perferred count' do
      line_items.each_with_index do |line_item, index|
        rule.should_receive(:product_eligible?).
          with(line_item.product).
          and_return(index < 2)
      end
      order.stub :line_items => line_items
      rule.should_not be_eligible(order)
    end

    it 'should not be eligible when number of products in taxon is less than perferred count' do
      line_items.each_with_index do |line_item, index|
        rule.should_receive(:product_eligible?).
          with(line_item.product).
          and_return(index == 0)
      end
      order.stub :line_items => line_items
      rule.should_not be_eligible(order)
    end

    it 'should correctly handle multiple quantity values' do
      line_items.first.stub(:quantity => 3)
      line_items.each_with_index do |line_item, index|
        rule.should_receive(:product_eligible?).
          with(line_item.product).
          and_return(index == 0)
      end
      order.stub :line_items => line_items
      rule.should be_eligible(order)
    end
  end

  context 'preferred operator set to gte' do
    before { rule.preferred_operator = 'gte' }

    it 'should be eligible when number of products in taxon is greater than perferred count' do
      line_items.each do |line_item|
        rule.should_receive(:product_eligible?).
          with(line_item.product).
          and_return(true)
      end
      order.stub :line_items => line_items
      rule.should be_eligible(order)
    end

    it 'should be eligible when number of products in taxon is equal to the perferred count' do
      line_items.each_with_index do |line_item, index|
        rule.should_receive(:product_eligible?).
          with(line_item.product).
          and_return(index < 2)
      end
      order.stub :line_items => line_items
      rule.should be_eligible(order)
    end

    it 'should not be eligible when number of products in taxon is less than perferred count' do
      line_items.each_with_index do |line_item, index|
        rule.should_receive(:product_eligible?).
          with(line_item.product).
          and_return(index == 0)
      end
      order.stub :line_items => line_items
      rule.should_not be_eligible(order)
    end

    it 'should correctly handle multiple quantity values' do
      line_items.first.stub(:quantity => 2)
      line_items.each_with_index do |line_item, index|
        rule.should_receive(:product_eligible?).
          with(line_item.product).
          and_return(index == 0)
      end
      order.stub :line_items => line_items
      rule.should be_eligible(order)
    end
  end
end
