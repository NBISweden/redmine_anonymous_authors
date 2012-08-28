class AddUserMailAndNameToJournals < ActiveRecord::Migration
  def self.up
    add_column :journals, :user_mail, :string, :null => true
    add_column :journals, :user_name, :string, :null => true
    add_index :journals, [:user_mail]
    add_index :journals, [:user_name]
  end

  def self.down
    remove_column :journals, :user_mail
    remove_column :journals, :user_name
  end
end
