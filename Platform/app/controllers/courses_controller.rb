class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
    @lessons = @course.lessons
  end

  def new
    @course = Course.new
    @teachers = User.all 
  end

  def create
    @course = Course.new(course_params)
    @course.user_id = current_user.id
    if @course.save
      flash[:notice] = "Course created successfully"
      redirect_to @course
    else
      flash.now[:alert] = "Error creating course"
      render :new
    end
  end

  def edit
  end

  def update
    if @course.update(course_params)
      flash[:notice] = "Course updated successfully"
      redirect_to @course
    else
      flash.now[:alert] = "Error updating course"
      render :edit
    end
  end

  def destroy
    @course.destroy
    flash[:notice] = "Course deleted successfully"
    redirect_to courses_path
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, :description, :teacher_id)
  end
end