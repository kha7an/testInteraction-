class CreateSkils < ActiveRecord::Migration[7.1]
  def change
    create_table :skils do |t|
      t.string :name

      t.timestamps
    end
  end
end
