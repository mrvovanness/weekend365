class RenameTableCompaniesSurveys < ActiveRecord::Migration
  def change
    rename_table :employees_surveys, :company_surveys_employees
  end
end
