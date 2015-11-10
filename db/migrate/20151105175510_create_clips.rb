class CreateClips < ActiveRecord::Migration
  def change
    create_table :clips do |t|
      t.string :href
      t.string :title
      t.integer :metafile_id

      t.timestamps null: false
    end
  end
end
