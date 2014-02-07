class Tweet < ActiveRecord::Base
	validates_uniqueness_of :twitter_id
	def init(tweet)
		puts tweet.inspect
		self.text = tweet.text
		self.time = tweet.created_at
		self.name = tweet.user.screen_name
		self.twitter_id = tweet.id
		if(!tweet.geo.nil? && !tweet.geo.coordinates.nil?)
			self.latitude = tweet.geo.coordinates[0]
			self.longitude = tweet.geo.coordinates[1]
		end
		return self
	end
end
