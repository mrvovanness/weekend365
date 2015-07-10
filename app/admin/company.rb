ActiveAdmin.register Company do
  index do
    selectable_column
    column :name
    actions
  end

  permit_params :name
end
