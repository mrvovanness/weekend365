class EmployeesController < ApplicationController
  def index
    @employees = []

    10.times do
      @employees << Employee.new(
        name: FFaker::Name.name,
        department: FFaker::Education.major
      )
    end
  end
end
