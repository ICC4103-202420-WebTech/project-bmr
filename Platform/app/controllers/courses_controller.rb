class CoursesController < ApplicationController
  load_and_authorize_resource except: [:my_courses]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_course, only: [:edit, :update, :destroy, :show]

  def index
    @courses = Course.all
    @popular_courses = Course.joins(:enrollments)
                              .group("courses.id")
                              .order("COUNT(enrollments.id) DESC")
                              .limit(5)
    @new_courses = Course.where("created_at >= ?", 1.week.ago).order(created_at: :desc)

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
    authorize! :read, :my_courses

    if current_user.role == "teacher"
      @created_courses = Course.where(teacher_id: current_user.id)
      @enrolled_courses = current_user.enrolled_courses
    elsif current_user.role == "student"
      @created_courses = []
      @enrolled_courses = current_user.enrolled_courses
    else
      redirect_to root_path, alert: "You are not authorized to access this page."
    end
  end

  def show
    @lessons = @course.lessons
    if current_user.enrolled_courses.include?(@course)
      @enrollment = Enrollment.find_by(user: current_user, course: @course)
    end
    unless user_signed_in?
      flash[:alert] = "You need to sign in to view course details."
      redirect_to new_user_session_path
    end
  end

  def new
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
    authorize! :update, @course
    unless current_user.id == @course.teacher_id
      flash[:alert] = "You are not authorized to edit this course."
      redirect_to courses_path
    end
  end

  def update
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
    authorize! :destroy, @course
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
