class Survey < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :company
  has_and_belongs_to_many :employees
  has_many :questions

  accepts_nested_attributes_for :questions, allow_destroy: true

end
