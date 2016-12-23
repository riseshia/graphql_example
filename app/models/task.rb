class Task < ApplicationRecord
  has_many :logs

  camel_case :estimated_size, :root_flg, :done_flg, :created_at

  def logged
    logs.count
  end
end
