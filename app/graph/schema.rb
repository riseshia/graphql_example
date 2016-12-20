TaskType = GraphQL::ObjectType.define do
  name 'Task'
  description 'A task'

  field :id, !types.ID
  field :estimated_size, !types.Int
  field :description, !types.String
  field :type, !types.String
  field :user_id, !types.Int
  field :created_at, !types.String
end

QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :task do
    type TaskType
    argument :id, !types.ID
    description "Find a Task by ID"
    resolve ->(_, args, _) { Task.find_by(id: args["id"]) }
  end
end

Schema = GraphQL::Schema.define { query QueryType }
