class CreateRoles < ActiveRecord::Migration

  def self.up

    create_table :roles do |t|
      t.string :name, :limit => 40
      t.string :title
      t.timestamps
    end

    add_index :roles, :name, :unique => true
    add_index :roles, :title, :unique => true

  end

  def self.down

    drop_table :roles
    remove_index :roles, :name
    remove_index :roles, :title, :unique => true

  end

end
