class WeekdayInput < SimpleForm::Inputs::Base
  def input
    @builder.select(attribute_name, I18n.t('date.day_names').map { |d| d.slice(0) }.to_a)
  end
end
