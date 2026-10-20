require "securerandom"

class AddJtiToUsers < ActiveRecord::Migration[7.2]
  def up
    add_column :users, :jti, :string

    select_values("SELECT id FROM users").each do |id|
      uuid = connection.quote(SecureRandom.uuid)

      execute <<~SQL
        UPDATE users
        SET jti = #{uuid}
        WHERE id = #{Integer(id)}
      SQL
    end

    change_column_null :users, :jti, false
    add_index :users, :jti, unique: true
  end

  def down
    remove_index :users, :jti
    remove_column :users, :jti
  end
end
