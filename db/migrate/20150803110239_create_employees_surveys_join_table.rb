class CreateEmployeesSurveysJoinTable < ActiveRecord::Migration
  def change
    create_table :employees_surveys, id: false do |t|
      t.belongs_to :employee, index: true
      t.belongs_to :survey, index:  true
    end
  end
end
