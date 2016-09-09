class Tag < DBObject
  attr_reader :id, :name

  TABLE = 'tages'

  def self.table
    TABLE
  end

  def initialize(attrs = {})
    @id = attrs['id']
    @name = attrs['name']
  end
end
