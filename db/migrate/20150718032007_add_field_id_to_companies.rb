class AddFieldIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :company_field_id, :integer
    add_index :companies, :company_field_id
    remove_column :companies, :field
  end
end
