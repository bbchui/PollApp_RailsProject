class Question < ApplicationRecord
  validates :text, presence: true, uniqueness: true

  def n_1_results
    results = Hash.new(0)
    answer_choices.each do |choice|
      results[choice.text] += choice.responses.length
    end
    results
  end

  def results
    results = Hash.new(0)
    answer_choices = self.answer_choices.includes(:responses)
    answer_choices.each do |choice|
      results[choice.text] += choice.responses.length
    end
    results
  end

  def sql_results
    a = AnswerChoice.find_by_sql([<<-SQL, self.id])
    SELECT answer_choices.text, COALESCE(COUNT(responses.id), 0) AS num_responses
    FROM answer_choices
    LEFT OUTER JOIN responses ON answer_choices.id = responses.answer_choice_id
    WHERE question_id = ?
    GROUP BY answer_choices.text
    SQL

    results = Hash.new(0)
    a.each do |choice|
      results[choice.text] += choice.num_responses
    end
    results
  end

  def ar_results
    a = self.answer_choices
      .select("answer_choices.text, COALESCE(COUNT(responses.id), 0) AS num_responses")
      .joins("LEFT OUTER JOIN responses ON answer_choices.id = responses.answer_choice_id")
      .where("question_id = ?", self.id)
      .group("answer_choices.text")

      results = Hash.new(0)
      a.each do |choice|
        results[choice.text] += choice.num_responses
      end
      results
  end

  has_many :answer_choices,
    primary_key: :id,
    foreign_key: :question_id,
    class_name: :AnswerChoice

  belongs_to :poll,
    primary_key: :id,
    foreign_key: :poll_id,
    class_name: :Poll

  has_many :responses,
    through: :answer_choices,
    source: :responses
end
