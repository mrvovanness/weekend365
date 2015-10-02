class ContactsController < ApplicationController
  layout 'devise'
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      respond_with @contact,
        location: -> { root_path }
    else
      render :new
    end
  end

  private

  def company_params
    params.require(:contact).permit(
      :name, :company_name, :email,
      :country, :message)
  end
end