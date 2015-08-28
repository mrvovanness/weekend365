class OfferedSurvey < ActiveRecord::Base
  validates :title, :type, presence: true
end
