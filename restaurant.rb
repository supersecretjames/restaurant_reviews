require_relative 'reviews_database'

class Restaurant

	def self.find(id)
		restaurant_data = ReviewsDatabase.execute(<<-SQL, id)
			SELECT *
			  FROM restaurants
			 WHERE restaurants.id = ?
		SQL

		restaurant_data.empty? ? nil : Restaurant.new(*restaurant_data)
	end

	def self.by_neighborhood
		restaurant_list = []

		restaurants = ReviewsDatabase.execute(<<-SQL)
			SELECT *
				FROM restaurants
		ORDER BY neighborhood
		SQL

		restaurants.map do |restaurant_hash|
			Restaurant.find(restaurant_hash['id'])
		end
	end

	def self.top_restaurants(n)
		top_list = RestaurantReview.top_restaurants

		top_list[0...n].map do |restaurant_hash|
			Restaurant.find(restaurant_hash['restaurant_id'])
		end
	end

	def self.highly_reviewed_restaurants(min_reviews)
		top_list = RestaurantReview.top_restaurants_with_min(min_reviews)

		top_list.map do |restaurant_hash|
			Restaurant.find(restaurant_hash['restaurant_id'])
		end
	end

	attr_reader :id, :name, :neighborhood, :cuisine

	def initialize(options={})
		@id, @name, @neighborhood, @cuisine = options.values_at('id', 'name', 'neighborhood', 'cuisine')
	end

	def reviews
		reviews = RestaurantReview.reviews_for_restaurant(@id)

		reviews.map do |review_hash|
			RestaurantReview.find(review_hash['id'])
		end
	end

	def average_review_score
		avg_score_hash = RestaurantReview.average_restaurant_rating(@id)

		avg_score_hash.first['avg_score']
	end
end