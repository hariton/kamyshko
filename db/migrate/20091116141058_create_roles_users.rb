class CreateRolesUsers < ActiveRecord::Migration

  def self.up

    create_table :roles_users, :id => false do |t| # HBTM-table
      t.references :role
      t.references :user
    end

    add_index :roles_users, [ :user_id, :role_id ]
    execute 'ALTER TABLE ONLY roles_users ADD CONSTRAINT roles_users_on_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;'
    execute 'ALTER TABLE ONLY roles_users ADD CONSTRAINT roles_users_on_role_id_fkey FOREIGN KEY (role_id) REFERENCES roles(id) ON UPDATE CASCADE ON DELETE CASCADE;'
  end

  def self.down

    drop_table :roles_users

    remove_index :roles_users, [ :user_id, :role_id ]
    execute 'ALTER TABLE ONLY roles_users DROP CONSTRAINT roles_users_on_user_id_fkey;'
    execute 'ALTER TABLE ONLY roles_users DROP CONSTRAINT roles_users_on_role_id_fkey;'
  end

end
