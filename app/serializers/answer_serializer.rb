class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :user

  belongs_to :question
  belongs_to :user 
  
end
