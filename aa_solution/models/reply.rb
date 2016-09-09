class Reply < DBObject
  attr_accessor :body
  attr_reader :id, :question_id, :parent_reply_id, :author_id

  TABLE = 'replies'

  def self.table
    TABLE
  end

  def initialize(attrs = {})
    @id = attrs['id']
    @question_id = attrs['question_id']
    @parent_reply_id = attrs['parent_reply_id']
    @author_id = attrs['author_id']
    @body = attrs['body']
  end

  def question
    Question.find_by_id(question_id)
  end

  def author
    User.find_by_id(author_id)
  end

  def parent_reply
    return nil unless parent_reply_id

    Reply.find_by_id(parent_reply_id)
  end

  def child_replies
    Reply.find_by_parent_reply_id(id)
  end

end
