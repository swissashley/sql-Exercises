class DBObject
  def self.find_by_id(id)
    data = QuestionDatabase.get_first_row(<<-SQL, id: id)
      SELECT
        *
      FROM
        #{table}
      WHERE
        id = :id
    SQL

    data.nil? ? nil : self.new(data)
  end

  def self.all
    data = QuestionDatabase.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table}
    SQL

    data.map { |obj_data| self.new(obj_data) }
  end

  def self.where(attrs)
    if attrs.is_a?(Hash)
      formatted_attrs = attrs.map do |key, val|
        formatted_val = val.is_a?(Integer) ? "#{val}" : "'#{val}'"
        "#{key} = "  + formatted_val
      end.join(" AND ")
    else
      formatted_attrs = attrs
    end

    data = QuestionDatabase.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table}
      WHERE
        #{formatted_attrs}
    SQL

    data.map { |obj_data| self.new(obj_data) }
  end

  def self.method_missing(method_name, *args)
    method_name = method_name.to_s
    if method_name.start_with?("find_by_")
      attribute_string = method_name[("find_by_".length)..-1]
      attribute_names = attribute_string.split("_and_")

      unless attribute_names.length == args.length
        raise "unexpected # of arguments"
      end

      search_conditions = {}
      attribute_names.each_index do |i|
        search_conditions[attribute_names[i]] = args[i]
      end

      self.where(search_conditions)
    else
      super
    end
  end

  def self.first
    data = QuestionDatabase.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table}
      LIMIT
        1
    SQL

    self.new(data.first)
  end

  def attrs
    Hash[instance_variables.map do |name|
      [name.to_s[1..-1], instance_variable_get(name)]
    end]
  end

  def create
    raise 'already saved!' unless self.id.nil?

    instance_attrs = attrs
    instance_attrs.delete("id")

    QuestionDatabase.execute(<<-SQL)
      INSERT INTO
        #{self.class.table} (#{instance_attrs.keys.join(", ")})
      VALUES
        ('#{instance_attrs.values.join("', '")}')
    SQL

    @id = QuestionDatabase.instance.last_insert_row_id
  end

  def update
    raise 'must create before updating' if self.id.nil?

    instance_attrs = attrs
    instance_attrs.delete("id")
    formatted_attrs = instance_attrs.map do |key, val|
      formatted_val = val.is_a?(Integer) ? "#{val}" : "'#{val}'"
      "#{key} = "  + formatted_val
    end.join(", ")

    QuestionDatabase.execute(<<-SQL, id: id)
      UPDATE
        #{self.class.table}
      SET
        #{formatted_attrs}
      WHERE
        id = :id
    SQL

    self
  end
end
