require_relative 'reviews_database'
require_relative 'restaurant_review'

class Critic

	def self.find(id)
		critic_data = ReviewsDatabase.execute(<<-SQL, id)
			SELECT *
			  FROM critics
			 WHERE critics.id = ?
		SQL

		critic_data.empty? ? nil : Critic.new(*critic_data)
	end

	attr_reader :id

	def initialize(options={})
		@id, @screen_name = options.values_at('id', 'screen_name')
	end

	def reviews
		reviews = RestaurantReview.reviews_by_critic(@id)

		reviews.map do |review_hash|
			RestaurantReview.find(review_hash['id'])
		end
	end

	def average_review_score
		avg_score_hash = RestaurantReview.average_critic_score(@id)

		avg_score_hash.first['avg_score']
	end

	def unreviewed_restaurants
		restaurants = RestaurantReview.unreviewed_restaurants(@id)

		restaurants.map do |restaurant_hash|
			Restaurant.find(restaurant_hash['id'])
		end
	end
end