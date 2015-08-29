class OfferedAnswer < ActiveRecord::Base
  validates :type, presence: true
end
