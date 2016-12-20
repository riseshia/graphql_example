class Task < ApplicationRecord
  has_many :logs

  def logged
    logs.count
  end
end
