class CreatePages < ActiveRecord::Migration

  def self.up

    create_table :pages, :force => true do |t|
      t.references :issue
      t.integer :number, :null => false
      t.string :digest, :limit => 32, :null => false
      t.text :text
      t.boolean :delta, :default => true, :null => false
    end

    add_index :pages, :issue_id
    add_index :pages, [:issue_id, :number], :unique => true
    execute 'ALTER TABLE ONLY pages ADD CONSTRAINT page_on_issue_id_fkey FOREIGN KEY (issue_id) REFERENCES issues(id) ON UPDATE CASCADE ON DELETE CASCADE;'

  end

  def self.down

    drop_table :pages

    remove_index :pages, :issue_id
    add_index :pages, [:issue_id, :number]
    execute 'ALTER TABLE ONLY pages DROP CONSTRAINT page_on_issue_id_fkey;'

  end

end
