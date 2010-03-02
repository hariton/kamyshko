class CreateProjectPages < ActiveRecord::Migration

  # отобранные страницы бывают трех состояний:
  # 1. найденная для проекта (это все ProjectPages-страницы, поэтому
  # дополнительного поля не предусмотрено, смысл - предотвратить повторный
  # поиск уже найденного)
  # 2. отобранная (валидная)
  # 3. отработанная

  def self.up
    create_table :project_pages do |t| # HMT-table
      t.references :project
      t.references :page
      t.integer :position
      t.boolean :selected, :default => true
      t.boolean :used, :default => false
    end
    add_index :project_pages, [:project_id, :page_id]
    add_index :project_pages, [:project_id, :position]
    execute 'ALTER TABLE project_pages ADD CONSTRAINT project_pages_on_project_id_fkey FOREIGN KEY (project_id) REFERENCES projects(id) ON UPDATE CASCADE ON DELETE CASCADE;'
    execute 'ALTER TABLE project_pages ADD CONSTRAINT project_pages_on_page_id_fkey FOREIGN KEY (page_id) REFERENCES pages(id) ON UPDATE CASCADE ON DELETE CASCADE;'
  end

  def self.down
    drop_table :project_pages
    remove_index :project_pages, [:project_id, :page_id]
    remove_index :project_pages, [:project_id, :position]
    execute 'ALTER TABLE project_pages DROP CONSTRAINT project_pages_on_project_id_fkey;'
    execute 'ALTER TABLE project_pages DROP CONSTRAINT project_pages_on_page_id_fkey;'
  end

end
