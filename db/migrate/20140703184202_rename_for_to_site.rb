class RenameForToSite < ActiveRecord::Migration
  def change
    rename_column :details, :for, :site
  end
end
