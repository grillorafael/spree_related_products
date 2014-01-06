# encoding: utf-8
require 'spec_helper'

describe "Products" do
  stub_authorization!
  context 'related products' do
    let!(:shipping_category) { create(:shipping_category) }
    let!(:product) { create(:product, shipping_category: shipping_category) }
    let!(:variant) { create(:variant, product: product) }

    before(:each) do
      @relation_type = Spree::RelationType.new name: 'Name', description: 'Im a description', applies_to: 'Spree::Product'
      @relation_type.save

      @relation = Spree::Relation.new relation_type: @relation_type, relatable: product, related_to: product
      @relation.save
    end

    it 'deletes a related product', driver: :selenium, js: true do
      visit spree.edit_admin_product_path product
      click_link 'Related Products'
      find('.delete-resource').click
      page.driver.browser.switch_to.alert.accept
      page.should have_content "Editing Product"
      within '#products-table-wrapper' do
        page.should_not have_content product.name
      end
    end
  end
end