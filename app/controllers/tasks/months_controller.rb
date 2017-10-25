class Tasks::MonthsController < ApplicationController
  before_action :verify_user, :validate_uri
  before_action :set_monthly_tasks, only: %i(index)

  def index
  end

  private

    def tasks_by_start
      Task.where(user: current_user, starts_at: @date.beginning_of_month..@date.end_of_month).map { |task| task.adjust_overnight_range(task.starts_at) }.group_by { |t| t.starts_at.day }
    end

    def tasks_by_end
      Task.where(user: current_user, ends_at: @date.beginning_of_month..@date.end_of_month).map { |task| task.adjust_overnight_range(task.ends_at) }.group_by { |t| t.ends_at.day }
    end

    def set_monthly_tasks
      @tasks = tasks_by_start.merge(tasks_by_end) { |_k, v1, v2| v1.concat(v2).uniq.sort_by { |t| t.starts_at } }
    end
end
