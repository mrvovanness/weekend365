class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable
  validates :company, :name, :email, presence: true
  validates :password, length: { minimum: 6 }, on: :update
  validates :terms_of_service, acceptance: true
  belongs_to :company, inverse_of: :users

  def is_admin?
    has_role? :admin
  end

  def is_admin_for?(company)
    has_role? :company_admin, company
  end

  def is_usual?
    !has_role? :admin
  end

  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

  def has_no_password?
    self.encrypted_password.blank?
  end

  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  protected

  def password_required?
    if !persisted?
      false
    else
      !password.nil? || !password_confirmation.nil?
    end
  end
end
