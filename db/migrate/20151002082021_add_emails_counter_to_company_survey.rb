class AddEmailsCounterToCompanySurvey < ActiveRecord::Migration
  def change
    add_column :company_surveys, :emails_counter, :integer, default: 0
  end
end
