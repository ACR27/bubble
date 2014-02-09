class MatchViewModel
	def init(match, name)
		@name = name
		@compatability = match.compatability
		@user_id = match.user2
		self
	end
end