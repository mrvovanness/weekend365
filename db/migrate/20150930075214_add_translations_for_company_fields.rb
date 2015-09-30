class AddTranslationsForCompanyFields < ActiveRecord::Migration
  def self.up
    CompanyField.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })
  end

  def self.down
    CompanyField.drop_translation_table! migrate_data: true
  end
end
