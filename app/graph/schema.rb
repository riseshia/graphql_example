TaskType = GraphQL::ObjectType.define do
  name 'Task'
  description 'A task'

  field :id, !types.ID
  field :estimatedSize, !types.Int
  field :logged, !types.Int
  field :description, !types.String
  field :rootFlg, !types.Boolean
  field :doneFlg, !types.Boolean
  field :createdAt, !types.String
end

QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  field :tasks do
    type types[!TaskType]
    description "Get all tasks"
    resolve ->(_, args, _) {
      user_id = 1
      Task.includes(:logs).where(user_id: user_id)
    }
  end
end

UpdateTaskMutation = GraphQL::Relay::Mutation.define do
  name "UpdateTask"

  input_field :id, !types.ID
  input_field :estimatedSize, types.Int
  input_field :description, types.String
  input_field :rootFlg, types.Boolean
  input_field :doneFlg, types.Boolean
  input_field :createdAt, types.String

  return_field :task, TaskType

  resolve ->(object, inputs, ctx) {
    task = Task.find_by(id: inputs[:id])
    inputs.to_h.each { |key, val| task.send("#{key}=", val) }
    task.save!
    { task: task }
  }
end

CreateTaskMutation = GraphQL::Relay::Mutation.define do
  name "CreateTask"

  input_field :estimatedSize, !types.Int
  input_field :description, !types.String
  input_field :rootFlg, !types.Boolean

  return_field :task, TaskType

  resolve ->(object, inputs, ctx) {
    user_id = 1
    task = Task.new(user_id: user_id)
    inputs.to_h.each { |key, val| task.send("#{key}=", val) }
    task.save!
    { task: task }
  }
end

DeleteTaskMutation = GraphQL::Relay::Mutation.define do
  name "DeleteTask"

  input_field :id, !types.ID

  return_field :id, !types.ID
  return_field :deleted, !types.Boolean

  resolve ->(object, inputs, ctx) {
    user_id = 1
    task = Task.find_by(id: inputs[:id], user_id: user_id)
    { id: task.id, deleted: task.destroy }
  }
end

CreateLogMutation = GraphQL::Relay::Mutation.define do
  name "CreateLog"

  input_field :taskId, !types.ID

  return_field :id, !types.ID
  return_field :taskId, !types.ID

  resolve ->(object, inputs, ctx) {
    log = Log.create!(task_id: inputs[:taskId])
    { id: log.id, taskId: log.task_id }
  }
end

DeleteLogMutation = GraphQL::Relay::Mutation.define do
  name "DeleteLog"

  input_field :taskId, !types.ID

  return_field :id, !types.ID
  return_field :taskId, !types.ID

  resolve ->(object, inputs, ctx) {
    log = Log.find_by(task_id: inputs[:taskId])
    log.destroy!
    { id: log.id, taskId: log.task_id }
  }
end

MutationType = GraphQL::ObjectType.define do name "Mutation"
  description "The mutation root of this schema"

  field :createTask, field: CreateTaskMutation.field
  field :updateTask, field: UpdateTaskMutation.field
  field :deleteTask, field: DeleteTaskMutation.field
  field :createLog, field: CreateLogMutation.field
  field :deleteLog, field: DeleteLogMutation.field
end

Schema = GraphQL::Schema.define do
  query QueryType
  mutation MutationType
end
