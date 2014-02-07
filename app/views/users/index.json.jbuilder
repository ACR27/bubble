json.array!(@users) do |user|
  json.extract! user, :id, :name, :twitter_handle, :gender
  json.url user_url(user, format: :json)
end
