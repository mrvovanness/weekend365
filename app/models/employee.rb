class Employee < ActiveRecord::Base
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  # Как вариант использовать https://github.com/kaize/validates и тогда просто "email: true"
  validates :email, format: { with: /\A[^@]+@[^@]+\z/ }

  belongs_to :company
end
