class Token < ActiveRecord::Base
  scope :valid, -> { where(expired: false) }
  scope :older_than, ->(date_selected) { where('created_at < ?', date_selected) }
end
