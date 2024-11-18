class AnswersController < ApplicationController
  before_action :set_course_and_lesson_and_question
  load_and_authorize_resource through: :question

  def create
    @answer = @question.answers.build(answer_params.merge(user: current_user))

    if @answer.save
      redirect_to course_lesson_path(@course, @lesson), notice: 'Answer posted successfully.'
    else
      redirect_to course_lesson_path(@course, @lesson), alert: 'Failed to post answer.'
    end
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    authorize! :destroy, @answer
    @answer.destroy
    redirect_to course_lesson_path(@course, @lesson), notice: 'Answer deleted successfully.'
  end

  private

  def set_course_and_lesson_and_question
    @course = Course.find(params[:course_id])
    @lesson = @course.lessons.find(params[:lesson_id])
    @question = @lesson.questions.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:content)
  end
end
