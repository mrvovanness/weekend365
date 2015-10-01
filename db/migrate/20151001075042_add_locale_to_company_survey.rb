class AddLocaleToCompanySurvey < ActiveRecord::Migration
  def change
    add_column :company_surveys, :locale, :string
  end
end
