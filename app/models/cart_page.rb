class CartPage < ActiveRecord::Base
  belongs_to :cart
  belongs_to :page
  acts_as_list :scope => :cart
  default_scope :order => :position

  alias prev higher_item
  alias next lower_item
end
