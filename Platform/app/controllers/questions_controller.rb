class QuestionsController < ApplicationController
  before_action :set_course_and_lesson
  load_and_authorize_resource through: :lesson

  def create
    @question = @lesson.questions.build(question_params.merge(user: current_user))

    if @question.save
      redirect_to course_lesson_path(@course, @lesson), notice: 'Question posted successfully.'
    else
      redirect_to course_lesson_path(@course, @lesson), alert: 'Failed to post question.'
    end
  end

  private

  def set_course_and_lesson
    @course = Course.find(params[:course_id])
    @lesson = @course.lessons.find(params[:lesson_id])
  end

  def question_params
    params.require(:question).permit(:content)
  end
end
