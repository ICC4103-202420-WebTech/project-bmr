class Lesson < ApplicationRecord
  belongs_to :course
  has_many :questions
  has_rich_text :content
end
