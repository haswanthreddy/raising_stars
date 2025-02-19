class Api::V1::TasksController < ApplicationController
  before_action :require_user_authentication
  before_action :set_user
  before_action :set_current_program

  def index 
    return no_active_program_response unless @current_program.present?

    tasks = []

    if range_type == "daily"
      tasks = daily_tasks(program_activities, range)
    else
      tasks = weekly_tasks(program_activities, week_start_day, week_end_day)
    end

    render json: {
      code: 200,
      status: "success",
      message: "#{range_type.capitalize} tasks successfully fetched",
      data: tasks
    }
  end

  private
  
  def daily_tasks(program_activities, day)
    weekday = (day % 7).to_i
    user_activities = user_activities(day)

    tasks = program_activities.select { |pc| pc.frequency == "daily" || pc.weekday_occurrences?(weekday) }
  
    tasks_response = tasks.map do |task|
      {
        id: task.id,
        name: task.activity.name,
        repetition: task.repetition,
        frequency: task.frequency,
        done: user_activities[task.activity_id] || false,
        activity_id: task.activity_id
      }
    end
  
    tasks_response
  end

  def weekly_tasks(program_activities, week_start_day, week_end_day)
    total_weeks_tasks = []

    (week_start_day..week_end_day).each do |day|
      tasks = daily_tasks(program_activities, day)

      total_weeks_tasks << tasks
    end

    total_weeks_tasks
  end

  def user_activities(target_day)
    target_date = @current_program.start_date.to_date + (target_day - 1).days
    start_of_day = target_date.beginning_of_day
    end_of_day = target_date.end_of_day

    Time.zone = 'Asia/Kolkata'
    target_date_in_app_timezone = target_date.in_time_zone(Time.zone)

    start_of_day = target_date_in_app_timezone.beginning_of_day
    end_of_day = target_date_in_app_timezone.end_of_day

    start_of_day_utc = start_of_day.utc
    end_of_day_utc = end_of_day.utc

    
    filtered_user_activities = @current_program.user_activities.where(created_at: start_of_day_utc..end_of_day_utc)

    user_activities = {}

    filtered_user_activities.each do |a|
      user_activities[a.activity_id] = true  
    end

    user_activities
  end
  
  def program_activities
    @program_activities ||= @current_program.program_activities
  end

  def week_start_day
    week_start_day ||= @current_program.current_week_start_day
  end

  def week_end_day
    week_end_day ||= @current_program.current_week_end_day
  end

  def no_active_program_response
    return render json: {
      code: 200,
      status: "success",
      message: "you have no active program"
    }, status: :ok
  end

  def set_user
    @user ||= Current.session.resource
  end

  def set_current_program
    @current_program ||= @user.current_program
  end

  def range
    current_day = index_filters[:range]
    
    if current_day.blank? && @current_program.present?
      current_day = @current_program.current_day
    end

    current_day.to_i
  end

  def range_type
    param_range_type = index_filters[:range_type]

    return JSON.parse(param_range_type) if param_range_type.present? 

    "daily"
  end

  def index_filters
    params.permit(:range_type, :range, :user_id)
  end
end
