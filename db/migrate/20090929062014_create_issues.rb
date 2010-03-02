class CreateIssues < ActiveRecord::Migration

  def self.up

    create_table :issues, :force => true do |t|
      t.references :source
      t.date :date, :null => false
      t.integer :number, :null => false
      t.boolean :active, :default => false, :null => false
      t.timestamps
    end

    add_index :issues, :source_id
    add_index :issues, [:source_id, :number, :date], :unique => true
    execute 'ALTER TABLE ONLY issues ADD CONSTRAINT issue_on_source_id_fkey FOREIGN KEY (source_id) REFERENCES sources(id) ON UPDATE CASCADE ON DELETE CASCADE;'

  end

  def self.down

    drop_table :issues

    remove_index :issues, :source_id
    remove_index :issues, [:source_id, :number, :date]
    execute 'ALTER TABLE ONLY issues DROP CONSTRAINT issue_on_source_id_fkey;'

  end

end
