TaskType = GraphQL::ObjectType.define do
  name 'Task'
  description 'A task'

  field :id, !types.ID
  field :estimated_size, !types.Int
  field :logged, !types.Int
  field :description, !types.String
  field :root_flg, !types.Boolean
  field :done_flg, !types.Boolean
  field :created_at, !types.String
end

QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :tasks do
    type types[!TaskType]
    description "Get all tasks"
    resolve ->(_, args, _) {
      Task.includes(:logs).where(user_id: args["user_id"])
    }
  end
end

UpdateTaskMutation = GraphQL::Relay::Mutation.define do
  name "UpdateTask"

  input_field :id, !types.ID
  input_field :description, !types.String

  return_field :task, TaskType

  resolve ->(object, inputs, ctx) {
    task = Task.find_by(id: inputs[:id])
    task.update!(inputs.to_h)
    { task: task }
  }
end

MutationType = GraphQL::ObjectType.define do
  name "Mutation"
  description "The mutation root of this schema"

  field :updateTask, field: UpdateTaskMutation.field
end

Schema = GraphQL::Schema.define do
  query QueryType
  mutation MutationType
end
