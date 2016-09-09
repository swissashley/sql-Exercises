require 'sqlite3'
require_relative 'question_database.rb'


class Follow < Model
  attr_accessor :question_id, :user_id
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    question_follows = database.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL

    question_follows.map{|datum| Follow.new(datum)}
  end

  def self.find_by_question_id(question_id)
    question_follows = database.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        question_id = ?
    SQL

    question_follows.map{|datum| Follow.new(datum)}
  end

  def self.find_by_user_id(user_id)
    question_follows = database.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        user_id = ?
    SQL

    question_follows.map{|datum| Follow.new(datum)}
  end

  def self.followers_for_question(question_id)
    followers = database.execute(<<-SQL, question_id)
      SELECT
        user_id
      FROM
        question_follows
      WHERE
        question_id = ?
    SQL

    # UGLY!!!
    followers.map{|datum| User.find_by_id(datum.values.first)}
  end

  def self.followed_questions_for_user_id(user_id)
    questions = database.execute(<<-SQL, user_id)
      SELECT
        DISTINCT questions.*
      FROM
        question_follows
      JOIN questions
      ON question_follows.user_id = ?
    SQL
    p questions
    questions.map {|datum| Question.new(datum)}

  end

  def self.all
    question_follows = database.execute("SELECT * FROM question_follows")
    question_follows.map{|datum| Follow.new(datum)}
  end

  def self.most_followed_questions(n)
    most_followed = database.execute(<<-SQL, n)
      SELECT
        questions.*,COUNT(*) AS followers
      FROM
        question_follows
      JOIN questions
      ON questions.id = question_follows.question_id
      GROUP BY
        questions.id
      ORDER BY COUNT(*) DESC
      LIMIT
      ?
    SQL

    most_followed.map {|datum| Question.new(datum)}
  end
end
