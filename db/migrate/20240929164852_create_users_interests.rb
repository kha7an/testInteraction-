class CreateUsersInterests < ActiveRecord::Migration[7.1]
  def change
    create_join_table :users, :interests
  end
end
