class Match < ActiveRecord::Base
	class << self
		def get_matches_for_user(user_id)
			response = []
			matches = Match.where(:user1 => user_id).order("compatability DESC")
			matches.each do |m|
				u = User.where(:twitter_id => m.user2).first
				puts u.inspect
				puts u.name.inspect
				mvm = MatchViewModel.new
				response << mvm.init(m,u.name)
			end
			response
		end
	end
end
