class QuestionLike < DBObject
  attr_reader :id, :user_id, :question_id

  TABLE = 'question_likes'

  def self.table
    TABLE
  end

  def initialize(attrs = {})
    @id = attrs['id']
    @user_id = attrs['user_id']
    @question_id = attrs['question_id']
  end

  def self.likers_for_question_id(question_id)
    user_data = QuestionDatabase.execute(<<-SQL, question_id: question_id)
      SELECT
        users.*
      FROM
        question_likes
      JOIN
        users ON user_id = users.id
      WHERE
        question_id = :question_id
    SQL

    user_data.map { |attrs| User.new(attrs) }
  end

  def self.num_likes_for_question_id(question_id)
    QuestionDatabase.get_first_value(<<-SQL, question_id: question_id)
      SELECT
        COUNT(*) AS likes
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        questions.id = :question_id
    SQL
  end
end
