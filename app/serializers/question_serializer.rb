class QuestionSerializer < ActiveModel::Serializer
  attributes :answers

  has_many :answers
  belongs_to :user

end
