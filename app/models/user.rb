class User < ActiveRecord::Base
	validates_uniqueness_of :twitter_id


end
