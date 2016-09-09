class QuestionFollow < DBObject
  attr_reader :id, :user_id, :question_id

  TABLE = 'question_follows'

  def self.table
    TABLE
  end

  def initialize(attrs = {})
    @id = attrs['id']
    @user_id = attrs['user_id']
    @question_id = attrs['question_id']
  end

  def self.followers_for_question_id(question_id)
    user_data = QuestionDatabase.execute(<<-SQL, question_id: question_id)
      SELECT
        users.*
      FROM
        questions
      JOIN
        question_follows ON question_follows.question_id = questions.id
      JOIN
        users ON question_follows.user_id = users.id
      WHERE
        questions.id = :question_id
    SQL

    user_data.map { |attrs| User.new(attrs) }
  end

  def self.followed_questions_for_user_id(user_id)
    question_data = QuestionDatabase.execute(<<-SQL, user_id: user_id)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows ON question_follows.question_id = questions.id
      JOIN
        users ON question_follows.user_id = users.id
      WHERE
        users.id = :user_id
    SQL

    question_data.map { |attrs| Question.new(attrs) }
  end

  def self.most_followed_questions(n)
    question_data = QuestionDatabase.execute(<<-SQL, limit: n)
      SELECT
        questions.*
      FROM
        questions
      JOIN
        question_follows ON question_follows.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_follows.id)
      LIMIT
        :limit
    SQL

    question_data.map { |attrs| Question.new(attrs) }
  end
end
