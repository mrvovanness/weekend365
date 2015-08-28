class OfferedAnswer < ActiveRecord::Base
  validates :value, presence: true
end
