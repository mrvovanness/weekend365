class Survey < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :company

end
