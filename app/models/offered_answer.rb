class OfferedAnswer < ActiveRecord::Base
  validates :value, :type, presence: true
end
