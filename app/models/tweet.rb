class Tweet < ActiveRecord::Base
	validates_uniqueness_of :twitter_id
	def init(tweet)
		puts tweet.inspect
		self.text = tweet.text
		self.time = tweet.created_at
		self.name = tweet.user.screen_name
		self.user_twitter_id = tweet.user.id
		self.twitter_id = tweet.id
		if(!tweet.geo.nil? && !tweet.geo.coordinates.nil?)
			self.latitude = tweet.geo.coordinates[0]
			self.longitude = tweet.geo.coordinates[1]
		end
		return self
	end

	class << self
		def get_max_tweet_id(twitter_id)
			max_id  = nil
			if(twitter_id.nil?)
				t = Tweet.order("twitter_id DESC").select(:twitter_id).first
				max_id = t.twitter_id unless t.nil?
			else
				t = Tweet.where(:user_twitter_id => twitter_id).order("twitter_id DESC").select(:twitter_id).first
				max_id = t.twitter_id unless t.nil?
			end
			max_id
		end

		# Takes a list of active record tweets and converts them to view models.
		def convert_tweets_to_view_models(tweets)
			response = []
			tweets.each do |tweet|
				t = TweetViewModel.new
				response << t.initFromActiveRecord(tweet)
			end
			response
		end
	end

	def is_retweet_or_mention
		first = self.text.chars[0]
		second = self.text.chars[1] if self.text.chars.size > 1
		if first.eql?('@') || (first.eql?('R') && second.eql?('T'))
			return true
		else
			return false
		end
	end
end
