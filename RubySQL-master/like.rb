require 'sqlite3'
require_relative 'question_database.rb'


class Like < Model
  attr_accessor :question_id, :user_id
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.find_by_id(id)
    question_likes = database.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL

    question_likes.map{|datum| Like.new(datum)}
  end

  def self.find_by_question_id(question_id)
    question_likes = database.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL

    question_likes.map{|datum| Like.new(datum)}
  end

  def self.find_by_user_id(user_id)
    question_likes = database.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        user_id = ?
    SQL

    question_likes.map{|datum| Like.new(datum)}
  end

  def self.num_likes_for_question_id(question_id)
    question_likes = database.execute(<<-SQL, question_id)
      SELECT
        COUNT(*)
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL

    question_likes.first.values.first
  end

  def self.all
    question_likes = database.execute("SELECT * FROM question_likes")
    question_likes.map{|datum| Like.new(datum)}
  end

  def self.likers_for_question_id(question_id)
    likers = database.execute(<<-SQL, question_id)
      SELECT
        users.*
      FROM
        question_likes
      JOIN
        users
          ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
      SQL

      likers.map{|datum| User.new(datum)}
  end

  def self.liked_questions_for_user_id(user_id)
    liked_questions = database.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
      SQL

      liked_questions.map{|datum| Question.new(datum)}
  end

  def self.most_liked_questions(n)
    liked_questions = database.execute(<<-SQL, n)
      SELECT
        questions.*, COUNT(*)
      FROM
        question_likes
      JOIN
        questions
      ON
        question_likes.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*), questions.id ASC
      LIMIT
        ?
    SQL

    liked_questions.map {|datum| Question.new(datum)}
  end

end
