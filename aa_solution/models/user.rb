class User < DBObject
  attr_accessor :fname, :lname
  attr_reader :id

  TABLE = 'users'

  def self.table
    TABLE
  end

  def initialize(attrs = {})
    @fname = attrs['fname']
    @lname = attrs['lname']
    @id = attrs['id']
  end

  def self.find_by_name(fname, lname)
    user_data = QuestionDatabase.get_first_row(<<-SQL, fname: fname, lname: lname)
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = :fname AND users.lname = :lname
    SQL

    user_data.nil? ? nil : User.new(user_data)
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_author_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end
end
