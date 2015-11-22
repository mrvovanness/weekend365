FactoryGirl.define do
  factory :department do
    name 'Finance'
    sequence(:code, 10) { |n| "dept#{n}" }
    company

    factory :department_with_employees do
      transient do
        employees_count 5
      end

      after(:create) do |department, evaluator|
        create_list(:employee, evaluator.employees_count, department: department)
      end
    end
  end
end
