class EnrollmentsController < ApplicationController
    before_action :set_course
  
    def create
      @enrollment = @course.enrollments.build(user: current_user)
      if @enrollment.save
        redirect_to course_path(@course), notice: 'Successfully enrolled in the course.'
      else
        redirect_to course_path(@course), alert: 'Could not enroll in the course.'
      end
    end
  
    def destroy
      @enrollment = @course.enrollments.find_by(user: current_user)
      @enrollment.destroy
      redirect_to course_path(@course), notice: 'Successfully unenrolled from the course.'
    end
  
    private
  
    def set_course
      @course = Course.find(params[:course_id])
    end
end
