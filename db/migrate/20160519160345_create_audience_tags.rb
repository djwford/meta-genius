class CreateAudienceTags < ActiveRecord::Migration
  def change
    create_table :audience_tags do |t|
      t.timestamps null: false
    end
  end
end
