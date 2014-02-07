require 'unirest'
require 'twitter'
class TwitterAPI
	@@twitter_base = 'https://api.twitter.com/1.1'
	@@client = nil
	@@max_id = 431135641448251392
	class << self
		# Gets and sets up the client singleton
		def authenticate
			#var request = unirest.post("https://api.twitter.com/oauth2/token?consumer_key=#{}&consumer_secret=");
  			if @@client.nil?
	  			@@client = Twitter::REST::Client.new do |config|
	  				config.consumer_key    = TW_CONSUMER_KEY
	  				config.consumer_secret = TW_CONSUMER_SECRET
	  				config.access_token = TW_ACCESS_TOKEN
  					config.access_token_secret = TW_ACCESS_TOKEN_SECRET
				end
			end
		end
		def get_local_tweets(lat,lng,radius, user_id)

			# Eventually want to search tweets by location
			# if it is a cache miss, load more tweets from twitter

			# TODO: show tweets user has not seen
			seen_ids = Interest.where(:user_id => user_id).select(:tweet_id).collect do |interest|
				interest.tweet_id
			end.uniq
			puts seen_ids.inspect
			if !seen_ids.nil? && !seen_ids.empty?
				tweets = Tweet.where("twitter_id NOT IN (?)", seen_ids).limit(20)
			else
				tweets = Tweet.all.limit(20)
			end
			convert_tweets_to_view_models(tweets)
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

		def load_tweets(lat,lng,radius)
			authenticate
			response = []
			last_tweet = Tweet.order("twitter_id DESC").select(:twitter_id).first
			if last_tweet.nil?
				max_id = @@max_id
			else
				max_id = last_tweet.twitter_id
			end
			puts "MAX_ID #{max_id.inspect}"
			begin
				result = @@client.search('lang:en',
					:geocode => "#{lat},#{lng},#{radius}",
					:since_id => max_id,
					:count => 100
					)
			rescue Exception => exc
				response << {:exception => exc}
			end

			result.each do |tweet|
				if(tweet.id > @@max_id)
					@@max_id = tweet.id
				end
				begin
					newTweet = Tweet.new
					newTweet = newTweet.initFromJSON(tweet)
					newTweet.save!
				rescue
					puts "COULD NOT SAVE"
				else
					t = TweetViewModel.new
					response << t.initFromActiveRecord(tweet)
				end
			end

			response
		end
	end
end