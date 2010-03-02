class CreateCarts < ActiveRecord::Migration

  def self.up
    create_table :carts do |t| # polymorphic-table
      t.integer    :collector_id
      t.string     :collector_type
    end
    add_index :carts, [:collector_id, :collector_type]
  end

  def self.down
    drop_table :carts
    remove_index :carts, [:collector_id, :collector_type]
  end

end
