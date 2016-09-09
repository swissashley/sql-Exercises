require 'sqlite3'
require_relative 'question_database.rb'


class Question < Model
  attr_accessor :title, :body, :author_id
  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id  =options['author_id']
  end

  # def self.find_by_id(id)
  #   questions = database.execute(<<-SQL, id)
  #     SELECT
  #       *
  #     FROM
  #       questions
  #     WHERE
  #       id = ?
  #   SQL
  #
  #   questions.map{|datum| Question.new(datum)}
  # end

  def self.find_by_author_id(author_id)
    questions = database.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    questions.map{|datum| Question.new(datum)}
  end

  def self.find_by_title(title)
    questions = database.execute(<<-SQL, title)
      SELECT
        *
      FROM
        questions
      WHERE
        title = ?
    SQL

    questions.map{|datum| Question.new(datum)}
  end

  def self.all
    questions = database.execute("SELECT * FROM questions")
    questions.map{|datum| Question.new(datum)}
  end

  def author
    users = Model.database.execute(<<-SQL, @author_id)
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
    SQL
    users.map{|datum| User.new(datum)}
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    Follow.followers_for_question(@id)
  end

  def self.most_followed(n)
    Follow.most_followed_questions(n)
  end

  def likers
    Like.likers_for_question_id(@id)
  end

  def num_likes
    Like.num_likes_for_question_id(@id)
  end

  def self.most_liked(n)
    Like.most_liked_questions(n)
  end

  # def save
  #   if @id.nil?
  #     question = Model.database.execute(<<-SQL, @title, @body, @author_id)
  #       INSERT INTO
  #         questions (title, body, author_id)
  #       VALUES
  #         (?,?,?)
  #     SQL
  #     @id = Model.database.last_insert_row_id
  #   else
  #     question = Model.database.execute(<<-SQL, @title, @body, @author_id, @id)
  #       UPDATE
  #         questions
  #       SET
  #         title = ?,
  #         body = ?,
  #         author_id = ?
  #       WHERE id = ?
  #     SQL
  #   end
  #   @id
  # end

end

if __FILE__ == $PROGRAM_NAME
  a = Question.new({'id' => nil, 'title' => 'nhh', 'body' => 'blah', 'author_id' => '2'})
  a.save
end
