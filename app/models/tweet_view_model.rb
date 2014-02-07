class TweetViewModel
	def initFromJSON(tweet)
		@text = tweet.text
		@time = tweet.created_at
		@name = tweet.user.screen_name
		@twitter_id = tweet.id
		return self
	end

	def initFromActiveRecord(tweet)
		@text = tweet.text
		@time = tweet.time
		@name = tweet.name
		@twitter_id = tweet.twitter_id
		return self
	end
end