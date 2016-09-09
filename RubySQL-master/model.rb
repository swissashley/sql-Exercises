require_relative 'question_database.rb'


class Model
  def self.database
    QuestionsDatabase.instance
  end

  def self.find_by_id(id)
    entries = database.execute("SELECT * FROM #{self.name.downcase + 's'} WHERE id = " + id.to_s)
    entries.map{|datum| self.new(datum)}
  end

  def save
    if @id.nil?
      i_vars = self.instance_variables
      i_vars.map!{|el| el.to_s}
      vals_hash = Hash.new
      i_vars.each{|el| p el; vals_hash[el] = eval(el)}
      p vals_hash
      non_id_values = vals_hash.keys[1..-1].join(', ')
      plural_class_name = self.class.name.downcase + 's'
      question_marks = ""
      (vals_hash.keys.length - 1).times{question_marks << "?,"}
      question_marks << "?"
      a=""
      p non_id_values
      p question_marks
      model = Model.database.execute(
      <<-SQL, non_id_values)
        INSERT INTO
          #{plural_class_name}
        VALUES
          (#{question_marks})
        SQL
      @id = Model.database.last_insert_row_id
    else

    end
  end
end
