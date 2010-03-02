class CreateSearchQueries < ActiveRecord::Migration

  def self.up
    create_table :search_queries do |t| # polymorphic-table
      t.integer    :searcher_id
      t.string     :searcher_type
      t.text       :query, :null => false
      t.date       :option_search_date_start
      t.date       :option_search_date_end
      t.text       :option_search_in_sources
      t.timestamp  :launched_at
      t.timestamps
    end
    add_index :search_queries, [:searcher_id, :searcher_type]
  end

  def self.down
    drop_table :search_queries
    remove_index :search_queries, [:searcher_id, :searcher_type]
  end

end
