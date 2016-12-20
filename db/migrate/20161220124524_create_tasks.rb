class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.integer :estimated_size
      t.string :description
      t.string :type
      t.integer :user_id
      t.boolean :status

      t.timestamps
    end
  end
end
