class Tasks::DaysController < ApplicationController
  before_action :verify_user, :validate_uri

  def index
    @tasks = Task.where(user: current_user, starts_at: @date.beginning_of_day..@date.end_of_day).or(Task.where(user: current_user, ends_at: @date.beginning_of_day..@date.end_of_day)).map { |task| task.adjust_overnight_range(@date) }.sort_by { |t| t.starts_at }
    @task = Task.new
  end
end
