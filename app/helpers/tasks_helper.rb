module TasksHelper
  def show_time_range(task)
    "#{I18n.l task.starts_at, format: :time} ~ #{I18n.l task.ends_at, format: :time}"
  end

  def set_time_select_to_now(date)
    min = date.min.floor.round(-1)
    if min == 60
      Time.zone.local(date.year, date.month, date.day, (date + 3600).hour, 0).strftime('%I:%M%p')
    else
      Time.zone.local(date.year, date.month, date.day, date.hour, min).strftime('%I:%M%p')
    end
  end

  def time_format_from_task(task)
    if task.to_hours > 0
      task.to_minutes == 0 ? "#{task.to_hours}#{I18n.t :hours}" : "#{task.to_hours}#{I18n.t :hours}#{task.to_minutes}#{I18n.t :minutes}"
    else
      "#{task.to_minutes}#{I18n.t :minutes}"
    end
  end

  def total_time_from_tasks(tasks, date)
    times = take_hours_and_minutes(tasks, date)
    time_format(times[:hours], times[:minutes])
  end

  def time_format(hours, minutes)
    if hours > 0
      minutes == 0 ? "#{hours}#{I18n.t :hours}" : "#{hours}#{I18n.t :hours}#{minutes}#{I18n.t :minutes}"
    else
      "#{minutes}#{I18n.t :minutes}"
    end
  end

  def take_hours_and_minutes(tasks, date)
    _tasks = tasks.map { |task| { hours: task.to_hours, minutes: task.to_minutes } }
    hours = _tasks.inject(0) { |total, task| total + task[:hours] }
    minutes = _tasks.inject(0) { |total, task| total + task[:minutes] }
    recalculate(hours, minutes)
  end

  def recalculate(hours, minutes)
    if minutes >= 60
      hours += (minutes / 60)
      minutes %= 60
    end
    { hours: hours, minutes: minutes }
  end
end
