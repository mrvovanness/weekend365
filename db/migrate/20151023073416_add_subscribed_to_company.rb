class AddSubscribedToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :subscribed, :boolean, default: true
  end
end
