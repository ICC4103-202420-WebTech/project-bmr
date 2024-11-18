class CreateCompletedLessons < ActiveRecord::Migration[7.2]
  def change
    create_table :completed_lessons do |t|
      t.references :enrollment, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true

      t.timestamps
    end
  end
end
