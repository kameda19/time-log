class Task < ApplicationRecord
  belongs_to :user

  def to_hours
    ((end_at - start_at) / 60 / 60).to_i
  end

  def to_minutes
    (((end_at - start_at) / 60) % 60).to_i
  end

  def is_overnight?
    start_at.day != end_at.day
  end

  def adjust_overnight_range(date)
    return self unless is_overnight?
    _task = self.clone
    if start_at < date.beginning_of_day
      _task.start_at = start_at.change(day: date.day, hour: 0, min: 0)
    elsif end_at > date.end_of_day
      _task.end_at = end_at.change(day: date.tomorrow.day, hour: 0, min: 0)
    end
    _task
  end
end
