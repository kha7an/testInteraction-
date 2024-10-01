class CreateUsersSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :skills_users, id: false do |t|
      t.integer :user_id, null: false
      t.integer :skill_id, null: false
    end
  end
end
