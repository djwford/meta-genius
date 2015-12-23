class AddTopicsListtoTags < ActiveRecord::Migration
  def change
    add_column :tags, :topics_list, :text
  end
end
