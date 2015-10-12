FactoryGirl.define do
  factory :company do
    name FFaker::Company.name
    country 'BR'
    company_field

    factory :company_with_employees do
      transient do
        employees_count 5
      end

      after(:create) do |company, evaluator|
        create_list(:employee, evaluator.employees_count, company: company)
      end
    end
  end
end
