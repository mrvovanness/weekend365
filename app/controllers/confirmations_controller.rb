class ConfirmationsController < Devise::ConfirmationsController
  skip_before_filter :authenticate_user!

  def update
    with_unconfirmed_confirmable do
      @confirmable.terms_of_service = params[:user][:terms_of_service]
      if @confirmable.has_no_password?
        @confirmable.attempt_set_password(params[:user])
        if @confirmable.valid?
          do_confirm
        else
          do_show
          @confirmable.errors.clear
        end
      else
        @confirmable.errors.add(:email, :password_already_set)
      end
    end

    if !@confirmable.errors.empty?
      render 'devise/confirmations/new'
    end
  end

  def show
    with_unconfirmed_confirmable do
      if @confirmable.has_no_password?
        do_show
      else
        do_confirm
      end
    end
    if !@confirmable.errors.empty?
      self.resource = @confirmable
      render 'devise/confirmations/new'
    end
  end

  protected

  def with_unconfirmed_confirmable
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token, params[:confirmation_token])
    if !@confirmable.new_record?
      @confirmable.only_if_unconfirmed {yield}
    end
  end

  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render 'devise/confirmations/show'
  end

  def do_confirm
    @confirmable.confirm
    set_flash_message :notice, :confirmed
    sign_in(resource_name, @confirmable)
    redirect_to edit_company_path(@confirmable.company)
  end
end
