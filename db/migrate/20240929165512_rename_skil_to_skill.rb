class RenameSkilToSkill < ActiveRecord::Migration[7.1]
  def change
    rename_table :skils, :skills
  end
end
