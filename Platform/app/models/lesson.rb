class Lesson < ApplicationRecord
  belongs_to :course
  has_many :questions, dependent: :destroy
  has_rich_text :content

  # Ordenar siempre por id
  default_scope { order(:id) }
end
