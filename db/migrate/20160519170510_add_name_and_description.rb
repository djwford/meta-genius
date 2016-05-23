class AddNameAndDescription < ActiveRecord::Migration
  def change
    add_column :audience_tags, :name, :string
    add_column :audience_tags, :description, :text

    add_column :certification_tags, :name, :string
    add_column :certification_tags, :description, :text

    add_column :search_keywords, :name, :string
    add_column :search_keywords, :description, :text

    add_column :tool_tags, :name, :string
    add_column :tool_tags, :description, :text

    add_column :topic_tags, :name, :string
    add_column :topic_tags, :description, :text

    add_column :tags, :name, :string
    add_column :tags, :description, :text    
  end
end
