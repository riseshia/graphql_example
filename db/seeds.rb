# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

(1..20).each do |i|
  task = Task.create(estimated_size: 10, description: "Todo#{i}", root_flg: false,
                     user_id: rand(1..5)1, done_flg: false)
  rand(3).times { Log.create(task_id: task.id) }
end
