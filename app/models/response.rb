class Response < ApplicationRecord

  validate :respondent_already_answered, :cant_respond_to_own_poll

  def sibling_responses
    self.question.responses.where.not(id: self.id)
  end

  def not_duplicate_response
    !sibling_responses.exists?(respondent.id)
  end


  belongs_to :respondent,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  belongs_to :answer_choice,
    primary_key: :id,
    foreign_key: :answer_choice_id,
    class_name: :AnswerChoice

  has_one :question,
    through: :answer_choice,
    source: :question

  private

  def respondent_already_answered
    if not_duplicate_response == false
      errors[:base] << "Can't enter duplicate responses!"
    end
  end

  def cant_respond_to_own_poll
    if self.answer_choice.question.poll.author_id == self.user_id
      errors[:base] << 'cannot respond to own poll'
    end
  end

end
