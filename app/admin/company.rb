ActiveAdmin.register Company do
  index do
    selectable_column
    column :name
    column :field
    actions
  end

  permit_params :user_id, :name, :field, :office_address, :country,
    :description, :website, :employees_number, :employees_registered
end
