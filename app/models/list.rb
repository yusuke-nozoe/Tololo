class List < ActiveRecord::Base
  has_many :cards
  accepts_nested_attributes_for :cards, allow_destroy: true, update_only: true
end
