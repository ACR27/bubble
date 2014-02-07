json.array!(@matches) do |match|
  json.extract! match, :id, :user1, :user2
  json.url match_url(match, format: :json)
end
