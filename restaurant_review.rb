require_relative 'reviews_database'

class RestaurantReview

	def self.find(id)
		review_data = ReviewsDatabase.execute(<<-SQL, id)
			SELECT *
			  FROM restaurant_reviews
			 WHERE restaurant_reviews.id = ?
		SQL

		review_data.empty? ? nil : RestaurantReview.new(*review_data)
	end

	def self.reviews_by_critic(critic_id)
		ReviewsDatabase.execute(<<-SQL, critic_id)
			SELECT *
			  FROM restaurant_reviews
			 WHERE reviewer_id = ?
		SQL
	end

	def self.average_critic_score(critic_id)
		ReviewsDatabase.execute(<<-SQL, critic_id)
			SELECT AVG(score) AS avg_score
			  FROM restaurant_reviews
			 WHERE reviewer_id = ?
		SQL
	end

	def self.reviews_for_restaurant(restaurant_id)
		ReviewsDatabase.execute(<<-SQL, restaurant_id)
			SELECT *
			  FROM restaurant_reviews
			 WHERE restaurant_id = ?
		SQL
	end

	def self.average_restaurant_rating(restaurant_id)
		ReviewsDatabase.execute(<<-SQL, restaurant_id)
			SELECT AVG(SCORE) AS avg_score
			  FROM restaurant_reviews
			 WHERE restaurant_id = ?
		SQL
	end

	def self.reviews_during_tenure(chef_id)
		ReviewsDatabase.execute(<<-SQL, chef_id)
			SELECT reviews.id
			  FROM restaurant_reviews reviews JOIN chef_tenures tenure
			  	ON reviews.restaurant_id = tenure.restaurant_id
			 WHERE (reviews.review_date > tenure.start_date 
			 	 AND reviews.review_date < tenure.end_date)
			 	 AND chef_id = ?
		SQL
	end

	def self.unreviewed_restaurants(critic_id)
		ReviewsDatabase.execute(<<-SQL, critic_id)
			SELECT id
			  FROM restaurants  
			 WHERE id NOT IN (SELECT restaurants.id 
			  							 FROM restaurant_reviews reviews JOIN restaurants
											 ON reviews.restaurant_id = restaurants.id
			 								 WHERE reviews.reviewer_id = ?
			 								 )
		SQL
	end

	def self.top_restaurants
		ReviewsDatabase.execute(<<-SQL)
			SELECT restaurant_id
				FROM restaurant_reviews
		GROUP BY restaurant_id
		ORDER BY AVG(score) DESC
		SQL
	end

	def self.top_restaurants_with_min(min_reviews)
		ReviewsDatabase.execute(<<-SQL, min_reviews)
			SELECT restaurant_id
				FROM restaurant_reviews
		GROUP BY restaurant_id
			HAVING COUNT(*) >= ?
		ORDER BY AVG(score) DESC
		SQL
	end

	def initialize(options={})
		@id, @reviewer_id, @restaurant_id, @text_review, @score, @review_date =
			options.values_at(
				'id', 
				'reviewer_id', 
				'restaurant_id', 
				'text_review',
				'score',
				'review_date'
				)
	end
end