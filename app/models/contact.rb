class Contact < MailForm::Base
  attribute :name, validate: true
  attribute :company_name, validate: true
  attribute :email, validate: true
  attribute :country

  attribute :message

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      subject: "Weekend Contact Form",
      to: "sales@weekendcult.com",
      from: "#{name} <#{email}>"
    }
  end
end