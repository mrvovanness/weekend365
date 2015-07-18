ActiveAdmin.register Company do
  index do
    selectable_column
    column :name
    actions
  end

  form do |f|
    inputs 'Details' do
      f.input :user, as: :select, collection: User.pluck(:email, :id)
      f.input :name
      f.input :company_field
      f.input :description
      f.input :website
      f.input :employees_number
      f.input :employees_registered
      f.input :country
      f.input :office_address
      actions
    end
  end
  permit_params :user_id, :name, :company_field_id, :office_address, :country,
    :description, :website, :employees_number, :employees_registered

end
