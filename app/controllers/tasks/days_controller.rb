class Tasks::DaysController < ApplicationController
  before_action :verify_user

  def index
    @date = Time.new(params[:year], params[:month], params[:day])
    @tasks = Task.where(user: current_user, start_at: @date.beginning_of_day..@date.end_of_day).or(Task.where(user: current_user, end_at: @date.beginning_of_day..@date.end_of_day))
    @task = Task.new
  end
end
