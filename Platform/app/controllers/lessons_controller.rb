class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  before_action :ensure_enrolled, only: [:show]

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

  def ensure_enrolled
    unless current_user.enrolled_courses.include?(@course) || @course.teacher == current_user
      redirect_to courses_path, alert: 'You must enroll in this course to access the lessons.'
    end
  end
end