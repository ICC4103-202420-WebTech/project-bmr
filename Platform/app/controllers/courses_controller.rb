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
      @courses = @popular_courses
    elsif params[:new]
      @title = "New Courses"
      @description = "Discover the latest courses added to our platform this past week. Stay up to date with fresh, exciting learning opportunities!"
      @courses = @new_courses
    else
      @title = "All Courses"
      @description = "Explore our diverse range of courses designed to enhance your skills and knowledge. Whether you're looking to advance your career or learn something new, we have something for everyone!"
      @courses = Course.all
    end
  end

  def my_courses
    # Added authorization to ensure proper permissions
    authorize! :read, :my_courses

    # Courses created by the current user
    @created_courses = Course.where(teacher_id: current_user.id)
    # Courses where the current user is enrolled
    @enrolled_courses = current_user.enrolled_courses
  end

  def show
    @course = Course.find(params[:id])
    @lessons = @course.lessons

    # Redirect guests to the sign-in page
    unless user_signed_in?
      flash[:alert] = "You need to sign in to view course details."
      redirect_to new_user_session_path
    end
  end

  def new
    # Restrict access to teachers only
    if current_user.role != "teacher"
      flash[:alert] = "You are not authorized to create a course."
      redirect_to courses_path
    else
      @course = Course.new
      @teachers = User.all
    end
  end

  def create
    @course = Course.new(course_params)
    @course.teacher = current_user
    if @course.save
      flash[:notice] = "Course created successfully!"
      redirect_to @course
    else
      flash.now[:alert] = "Error creating course"
      render :new
    end
  end

  def edit
    # Ensure only the teacher who created the course can edit it
    unless current_user.id == @course.teacher_id
      flash[:alert] = "You are not authorized to edit this course."
      redirect_to courses_path
    end
  end

  def update
    # Ensure only the teacher who created the course can update it
    unless current_user.id == @course.teacher_id
      flash[:alert] = "You are not authorized to update this course."
      redirect_to courses_path
    else
      if @course.update(course_params)
        flash[:notice] = "Course updated successfully!"
        redirect_to @course
      else
        flash.now[:alert] = "Error updating course"
        render :edit
      end
    end
  end

  def destroy
    # Ensure only the teacher who created the course can delete it
    unless current_user.id == @course.teacher_id
      flash[:alert] = "You are not authorized to delete this course."
      redirect_to courses_path
    else
      @course.destroy
      flash[:notice] = "Course deleted successfully"
      redirect_to courses_path
    end
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

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, :description, :teacher_id)
  end
end
