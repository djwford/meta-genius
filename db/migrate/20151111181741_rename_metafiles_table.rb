class RenameMetafilesTable < ActiveRecord::Migration
  def change
    rename_table :metafiles, :module_metafiles
  end
end
