FactoryGirl.define do
  factory :company do
    name FFaker::Company.name
    country 'BR'
    company_field

    factory :company_with_departments do
      transient do
        employees_count 5
      end

      after(:create) do |company, evaluator|
        create_list(:department, evaluator.employees_count, company: company)
      end

      factory :company_with_department_with_employees do
        transient do
          employees_count 5
        end

        after(:create) do |company, evaluator|
          create_list(:department, evaluator.employees_count, company: company)
        end

        after(:create) do |company, evaluator|
          create_list(:employee, evaluator.employees_count, department: company.departments.first)
        end
      end
    end
  end
end
