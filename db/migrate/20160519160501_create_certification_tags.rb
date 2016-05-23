class CreateCertificationTags < ActiveRecord::Migration
  def change
    create_table :certification_tags do |t|
      t.timestamps null: false
    end
  end
end
