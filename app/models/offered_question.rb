class OfferedQuestion < ActiveRecord::Base
  validates :title, presence: true

  has_and_belongs_to_many :company_surveys
  has_many :sqa_assignments, dependent: :destroy
  has_many :offered_answers, through: :sqa_assignments
  has_many :offered_surveys, through: :sqa_assignments

  after_create :set_default_answers

  translates :title, :topic, :subtopic

  def self.import(file)
    spreadsheet = Spreadsheet.new(file)
    spreadsheet.import(self.model_name.name)
  end

  private

  def set_default_answers
    if self.offered_answers.empty?
      self.offered_answers = OfferedAnswer.all
    end
  end
end
