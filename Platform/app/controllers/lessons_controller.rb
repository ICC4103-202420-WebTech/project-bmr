class LessonsController < ApplicationController
  before_action :set_course
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @lesson = @course.lessons.new
  end

  def create
    @lesson = @course.lessons.new(lesson_params)
    if @lesson.save
      flash[:notice] = "Lesson created successfully"
      redirect_to course_lesson_path(@course, @lesson)
    else
      flash.now[:alert] = "Error creating lesson"
      render :new
    end
  end

  def edit
  end

  def update
    if @lesson.update(lesson_params)
      flash[:notice] = "Lesson updated successfully"
      redirect_to course_lesson_path(@course, @lesson)
    else
      flash.now[:alert] = "Error updating lesson"
      render :edit
    end
  end

  def destroy
    @lesson.destroy
    flash[:notice] = "Lesson deleted successfully"
    redirect_to course_path(@course)
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_lesson
    @lesson = @course.lessons.find(params[:id])
  end

  def lesson_params
    params.require(:lesson).permit(:title, :content, :lesson_type, :video_url)
  end
end
