class RenameTableSurveys < ActiveRecord::Migration
  def change
    rename_table :surveys, :company_surveys
  end
end
