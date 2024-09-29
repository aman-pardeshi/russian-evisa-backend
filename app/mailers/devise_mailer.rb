class DeviseMailer < Devise::Mailer

  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views
  # If there is an object in your application that returns a contact email, you can use it as follows
  # Note that Devise passes a Devise::Mailer object to your proc, hence the parameter throwaway (*).
  def reset_password_instructions(record, token, opts={})
    if record.source
      opts[:template_name] = "send_reset_password_link"
      opts[:subject]= I18n.t("mailer.reset_password_instruction.subject")
    end
    super
  end

  def confirmation_instructions(record, token, opts={})
    opts[:template_name] = "confirmation_instructions"
    opts[:subject] = I18n.t("mailer.confirmation_instructions.subject")
    super
  end
end
