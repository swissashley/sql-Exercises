class Question < DBObject
  attr_accessor :title, :body
  attr_reader :id, :author_id

  TABLE = 'questions'

  def self.table
    TABLE
  end

  def initialize(attrs = {})
    @id = attrs['id']
    @title = attrs['title']
    @body = attrs['body']
    @author_id = attrs['author_id']
  end

  def self.find_by_author_id(author_id)
    data = QuestionDatabase.execute(<<-SQL, author_id: author_id)
      SELECT
        *
      FROM
        #{table}
      WHERE
        author_id = :author_id
    SQL

    data.map { |obj_data| self.new(obj_data) }
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def author
    User.find_by_id(author_id)
  end

  def replies
    Reply.find_by_question_id(id)
  end

  def followers
    QuestionFollow.followers_for_question_id(id)
  end

end
