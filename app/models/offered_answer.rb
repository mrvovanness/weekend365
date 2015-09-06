class OfferedAnswer < ActiveRecord::Base
  validates :type, presence: true
  has_many :answers
end
