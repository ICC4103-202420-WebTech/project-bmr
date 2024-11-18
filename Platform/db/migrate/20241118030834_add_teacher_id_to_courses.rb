class AddTeacherIdToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :teacher_id, :integer
    add_foreign_key :courses, :users, column: :teacher_id
  end
end
