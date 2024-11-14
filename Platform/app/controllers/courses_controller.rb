class CoursesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_course, only: [:edit, :update, :destroy]

  def index
    @courses = Course.all
    # Get the most popular courses (top 5 based on enrollments)
    @popular_courses = Course.joins(:enrollments)
                              .group("courses.id")
                              .order("COUNT(enrollments.id) DESC")
                              .limit(5)

    # Get the new courses created in the past week
    @new_courses = Course.where("created_at >= ?", 1.week.ago).order(created_at: :desc)

    # If a query for 'popular' or 'new' is passed
    if params[:popular]
      @title = "Popular Courses"
      @description = "Explore the most popular courses chosen by our users. These are the 5 courses that have made the biggest impact!"
      @courses = Course.joins(:enrollments)
                       .group("courses.id")
                       .order("COUNT(enrollments.id) DESC")
                       .limit(5)
    elsif params[:new]
      @title = "New Courses"
      @description = "Discover the latest courses added to our platform this past week. Stay up to date with fresh, exciting learning opportunities!"
      @courses = Course.where("created_at >= ?", 1.week.ago).order(created_at: :desc)
    else
      @title = "All Courses"
      @description = "Explore our diverse range of courses designed to enhance your skills and knowledge. Whether you're looking to advance your career or learn something new, we have something for everyone!"
      @courses = Course.all
    end
  end
  
  def my_courses
    @enrolled_courses = current_user.enrolled_courses
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

  def enroll
    @course = Course.find(params[:id])
  
    if current_user.enrolled_courses.include?(@course)
      redirect_to course_path(@course), alert: "You are already enrolled in this course."
    else
      @course.users << current_user 
  
      redirect_to courses_path, notice: "Successfully enrolled in #{@course.title}."
    end
  end

  def my_courses
    @created_courses = current_user.courses
    @enrolled_courses = current_user.enrolled_courses
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, :description, :teacher_id)
  end
end
