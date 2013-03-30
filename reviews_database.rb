require 'singleton'
require 'sqlite3'

class ReviewsDatabase < SQLite3::Database
	include Singleton

	def initialize
		super('reviews.db')

		self.results_as_hash = true
		self.type_translation = true
	end

	def self.execute(*args)
		self.instance.execute(*args)
	end
end