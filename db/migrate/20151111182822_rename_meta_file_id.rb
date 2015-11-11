class RenameMetaFileId < ActiveRecord::Migration
  def change
    rename_column :clips, :metafile_id, :module_metafile_id
  end
end
