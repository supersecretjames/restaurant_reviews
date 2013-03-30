require_relative 'reviews_database'

class ChefTenure

	def self.find_cohorts(chef_id)
		ReviewsDatabase.execute(<<-SQL, chef_id)
			SELECT DISTINCT others.chef_id
				FROM chef_tenures AS me 
				JOIN chef_tenures AS others
					ON me.restaurant_id = others.restaurant_id
			 WHERE others.chef_id != ?
				 AND ((me.start_date < others.start_date AND me.start_date < others.start_date)	
				  OR (me.end_date > others.start_date AND me.end_date < others.end_date))	 	 
		SQL
	end
end