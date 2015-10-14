class AddTimezoneToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :timezone, :string, default: "Asia/Tokyo"
  end
end
