class CreateCartPages < ActiveRecord::Migration

  def self.up
    create_table :cart_pages do |t| # HMT-table
      t.references :cart
      t.references :page
      t.integer :position
    end
    add_index :cart_pages, [:cart_id, :page_id]
    add_index :cart_pages, [:cart_id, :position]
    execute 'ALTER TABLE ONLY cart_pages ADD CONSTRAINT cart_pages_on_cart_id_fkey FOREIGN KEY (cart_id) REFERENCES carts(id) ON UPDATE CASCADE ON DELETE CASCADE;'
    execute 'ALTER TABLE ONLY cart_pages ADD CONSTRAINT cart_pages_on_page_id_fkey FOREIGN KEY (page_id) REFERENCES pages(id) ON UPDATE CASCADE ON DELETE CASCADE;'
  end

  def self.down
    drop_table :cart_pages
    remove_index :cart_pages, [:cart_id, :page_id]
    remove_index :cart_pages, [:cart_id, :position]
    execute 'ALTER TABLE ONLY cart_pages DROP CONSTRAINT cart_pages_on_cart_id_fkey;'
    execute 'ALTER TABLE ONLY cart_pages DROP CONSTRAINT cart_pages_on_page_id_fkey;'
  end

end
