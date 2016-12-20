json.extract! task, :id, :estimated_size, :description, :type, :user_id, :status, :created_at, :updated_at
json.url task_url(task, format: :json)