require_relative 'reviews_database'
require_relative 'chef_tenure'

class Chef

	def self.find(id)
		chef_data = ReviewsDatabase.execute(<<-SQL, id)
			SELECT *
			  FROM chefs
			 WHERE chefs.id = ?
		SQL

		chef_data.empty? ? nil : Chef.new(*chef_data)
	end

	attr_reader :id, :fname, :lname, :mentor

	def initialize(options={})
		@id, @fname, @lname, @mentor = options.values_at('id', 'fname', 'lname', 'mentor')
	end

	def num_proteges 
		protege_count = ReviewsDatabase.execute(<<-SQL, @id)
			SELECT COUNT(*) AS count
			  FROM chefs
			 WHERE mentor = ?
		SQL

		protege_count.first['count']
	end

	def proteges 
		protege_list = ReviewsDatabase.execute(<<-SQL, @id)
			SELECT id
			  FROM chefs
			 WHERE mentor = ?
		SQL

		protege_list.map do |chef_hash|
			Chef.find(chef_hash['id'])
		end
	end

	def co_workers
		co_worker_list = ChefTenure.find_cohorts(@id)

		co_worker_list.map do |chef_hash|
			Chef.find(chef_hash['chef_id'])
		end
	end

	def reviews
		reviews = RestaurantReview.reviews_during_tenure(@id)

		reviews.map do |review_hash|
			RestaurantReview.find(review_hash['id'])
		end
	end
end