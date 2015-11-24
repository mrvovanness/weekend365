class OfferedQuestion < ActiveRecord::Base
  validates :title, :topic, presence: true

  has_and_belongs_to_many :company_surveys
  has_many :sqa_assignments, dependent: :destroy
  has_many :offered_answers, through: :sqa_assignments
  has_many :offered_surveys, through: :sqa_assignments

  before_save :set_default_answers, :set_base_for_correlation

  translates :title, :topic, :subtopic

  def self.import(file)
    spreadsheet = Spreadsheet.new(file)
    spreadsheet.import(self.model_name.name)
  end

  def set_default_answers
    case form_of_answers
    when '1-5 scale'
      self.offered_answers = OfferedAnswer.first(5)
    when '1-10 scale'
      self.offered_answers = OfferedAnswer.first(10)
    when 'open'
      self.offered_answers = []
    end
  end

  def set_base_for_correlation
    if self.base_for_correlation == true
      old_base = OfferedQuestion.where(base_for_correlation: true)
      old_base.each { |q| q.update_column(:base_for_correlation, false)}
    end
  end

  def open?
    form_of_answers == 'open'
  end

end
