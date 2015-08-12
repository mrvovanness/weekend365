class Question < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :survey
end
