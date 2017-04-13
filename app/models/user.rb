class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true

  def completed_polls
    a = Poll.find_by_sql([<<-SQL, self.id])
    SELECT polls.title, COALESCE(COUNT(questions.id), 0) AS num_questions
    FROM polls
    LEFT OUTER JOIN questions ON polls.id = questions.poll_id
    WHERE polls.author_id = ?
    GROUP BY polls.title
    SQL
    results = Hash.new(0)
    a.each do |poll|
      results[poll.title] += poll.num_questions
    end
    results
  end

  has_many :authored_polls,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: :Poll

  has_many :responses,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Response

end
