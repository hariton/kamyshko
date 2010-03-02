class CreateSources < ActiveRecord::Migration

  def self.up

    create_table :sources, :force => true do |t|
      t.string :title, :null => false
      t.string :site_url
      t.timestamps
    end

    add_index :sources, :title, :unique => true

  end

  def self.down

    drop_table :sources

    remove_index :sources, :title

  end

end
