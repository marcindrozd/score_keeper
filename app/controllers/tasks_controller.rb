class TasksController < ApplicationController

  def index
    @exam = Exam.find(params[:exam_id])
    @tasks = @exam.tasks
    @tasks_standard = @exam.tasks.standard
    @tasks_extended = @exam.tasks.extended
    @tasks_bilingual = @exam.tasks.bilingual
    @subtasks = @tasks.map { |task| task.subtasks }.flatten
  end

  def new
    @exam = Exam.find(params[:exam_id])
    @task = @exam.tasks.new
  end

  def create
    @exam = Exam.find(params[:exam_id])
    @task = @exam.tasks.new(task_params)
    @task.skill = Skill.find_by_name(params[:task][:skill])

    if @task.save
      redirect_to exam_tasks_url, notice: 'Task created!'
      TaskScoresHandler.new(@exam, @task).add_task_to_all_students
    else
      render :new
    end
  end

  def edit
    @exam = Exam.find(params[:exam_id])
    @task = @exam.tasks.find(params[:id])
  end

  def update
    @exam = Exam.find(params[:exam_id])
    @task = @exam.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to exam_tasks_url, notice: 'Task updated!'
      TaskScoresHandler.new(@exam, @task).add_task_to_all_students
    else
      render :edit
    end
  end

  private

  def task_params
    params.require(:task).permit(:number, :level, subtasks_attributes: [:id, :name, :max_points, :_destroy])
  end
end
