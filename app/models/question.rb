class Question < ApplicationRecord
  belongs_to :lesson
  belongs_to :user

  has_many :answers, dependent: :destroy
  validates :content, presence: true
end
