class AddAuthorMailToIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :author_name, :string, :null => true
    add_column :issues, :author_mail, :string, :null => true
    add_index :issues, [:author_name]
    add_index :issues, [:author_mail]
  end

  def self.down
    remove_column :issues, :author_mail
    remove_column :issues, :author_name
  end
end
