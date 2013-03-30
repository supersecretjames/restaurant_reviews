class Model
	def self.table_name
		raise "NotImplementedError"
	end

	def self.find(id)
		result = QDatabase.instance.execute(<<-SQL, id)
      SELECT *
        FROM self.plural_name 
       WHERE id = ?
      SQL

    self.new(*result)  
	end

	def self.all(id)
		QDatabase.instance.execute(<<-SQL, id)
			SELECT *
				FROM self.plural_name 
			SQL
	end

	protected

	def attr_accessible(column_names)
		
	end

end