class ApiController < ApplicationController

	# GET /api/localTweets
	def getLocalTweets
		# TODO get correct parameters
		lat = params[:latitude] || "47.613959"
		lng = params[:longitude] || "-122.349214"
		user_id = params[:user_id]
		render json: TwitterAPI.get_local_tweets(lat,lng, DEFAULT_RADIUS, user_id)
	end

	# GET /api/localTweets
	def loadTweets
		render json: TwitterAPI.load_tweets("47.613959","-122.349214","10mi")
	end

	def loadUserTweets
		render json: TwitterAPI.load_tweets_for_user(params[:twitter_id])
	end

	# Gets three tweets from the passed in user.
	# GET /api/getThreeTweets
	def getThreeTweets
		render json: TwitterAPI.get_top_3_tweets(params[:twitter_id])
	end

	def loadBulkTweets
		render json: TwitterAPI.load_bulk_tweets(params[:twitter_id])
	end

	#GET /api/getMatches
	def getMatches
		matches = Match.get_matches_for_user(params[:twitter_id])
		render json: matches
	end

	#GET /api/getMatchCount
	# Gets the number of matches
	def getMatchCount
		render json: Match.count(:user1 => params[:twitter_id])
	end

	#POST /api/likeTweet
	def likeTweet
		# PUT THIS IN HELPER METHOD
		begin
			i = Interest.new
			i.user_id = params[:user_id]
			i.tweet_id = params[:twitter_id]
			i.like_count = 1
			i.save!
		rescue Exception => exc
			render json: false
		else
			# analyze tweet
			# find potential matches
			render json: true
		end
	end

	#POST /api/likeTweet
	def dislikeTweet
		begin
			i = Interest.new
			i.user_id = params[:user_id]
			i.tweet_id = params[:twitter_id]
			i.like_count = -1
			i.save!
		rescue Exception => exc
			render json: false
		else
			# analyze tweet
			# find potential matches
			render json: true
		end
	end

	#GET /api/tryLogin
	def tryLogin
		user = User.find_by_twitter_id(params[:twitter_id])
		if user.nil?
			render json: false
		else
			render json: user
		end
	end

	#POST /api/createUser
	def createUser
		user = User.new
		user.name = params[:name]
		user.twitter_handle = params[:twitter_handle]
		user.gender = params[:gender]
		user.twitter_id = params[:twitter_id]
		if(user.save!)
			render json: user
		else
			render json: {:error => "Could not generate user"}
		end
	end
end