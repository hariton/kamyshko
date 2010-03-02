class CreateProjects < ActiveRecord::Migration

  def self.up
    create_table :projects do |t|
      t.references :user
      t.references :search_query
      t.string :title, :null => false
      t.integer :position
      t.integer :search_days
      t.timestamps
    end
    add_index :projects, :title, :unique => true
    execute 'ALTER TABLE projects ADD CONSTRAINT projects_on_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;'
    execute 'ALTER TABLE projects ADD CONSTRAINT projects_on_search_query_id_fkey FOREIGN KEY (search_query_id) REFERENCES search_queries(id) ON UPDATE CASCADE ON DELETE CASCADE;'
  end

  def self.down
    drop_table :projects
    remove_index :projects, :title
    execute 'ALTER TABLE projects DROP CONSTRAINT projects_on_user_id_fkey;'
    execute 'ALTER TABLE projects DROP CONSTRAINT projects_on_search_query_id_fkey;'
  end

end
