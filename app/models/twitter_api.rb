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
			Tweet.convert_tweets_to_view_models(tweets)
		end



		# LOADS ONLY RECENT TWEETS FOR A USER
			def load_tweets_for_user(user_id)
			authenticate
			max_id = Tweet.get_max_tweet_id(user_id) || @@max_id

			response = []
			puts max_id
			result = @@client.user_timeline(user_id.to_i, :since_id => max_id)
			result.each do |tweet|
				begin
					newTweet = Tweet.new
					newTweet = newTweet.init(tweet)
					unless newTweet.is_retweet_or_mention
						newTweet.save!
					else
						puts "Found Retweet #{newTweet.text}"
					end
				rescue
					puts "COULD NOT SAVE"
				else
					t = TweetViewModel.new
					response << t.initFromActiveRecord(newTweet)
				end
			end
			response
		end

		# LOAD ALL TWEETS FOR A USER
		def load_bulk_tweets(user_id)
			authenticate

			response = []
			result = @@client.user_timeline(user_id.to_i)
			result.each do |tweet|
				begin
					newTweet = Tweet.new
					newTweet = newTweet.init(tweet)
					newTweet.save!
				rescue
					puts "COULD NOT SAVE"
				else
					t = TweetViewModel.new
					response << t.initFromActiveRecord(newTweet)
				end
			end
			response
		end

		# LOAD LOCAL TWEETS
		def load_tweets(lat,lng,radius)
			authenticate
			response = []
			max_id = Tweet.get_max_tweet_id(nil) || @@max_id
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
					newTweet = newTweet.init(tweet)
					unless newTweet.is_retweet_or_mention
						newTweet.save!
					else
						puts "Found Retweet #{newTweet.text}"
					end
				rescue Exception => exc
					puts exc.message
				else
					t = TweetViewModel.new
					response << t.initFromActiveRecord(newTweet)
				end
			end

			response
		end

		def get_top_3_tweets(user_id)
			tweets = Tweet.where(:user_twitter_id => user_id).order("twitter_id DESC").limit(3)
			Tweet.convert_tweets_to_view_models(tweets)
		end
	end

end