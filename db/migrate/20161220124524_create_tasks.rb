class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.integer :estimated_size
      t.string :description
      t.integer :user_id
      t.boolean :root_flg
      t.boolean :done_flg

      t.timestamps
    end
  end
end
