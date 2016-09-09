require 'singleton'
require 'sqlite3'

class QuestionDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')

    # Typically each row is returned as an array of values; it's more
    # convenient for us if we receive hashes indexed by column name.
    self.results_as_hash = true

    # Typically all the data is returned as strings and not parsed
    # into the appropriate type.
    self.type_translation = true
  end

  def self.execute(*args)
    self.instance.execute(*args)
  end

  def self.get_first_row(*args)
    self.instance.get_first_row(*args)
  end

  def self.insert_last_row(*args)
    self.instance.insert_last_row(*args)
  end

  def self.get_first_value(*args)
    self.instance.get_first_value(*args)
  end
end
