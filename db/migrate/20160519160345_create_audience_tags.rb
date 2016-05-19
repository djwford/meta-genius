class CreateAudienceTags < ActiveRecord::Migration
  def change
    create_table :audience_tags do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
    end
  end
end
