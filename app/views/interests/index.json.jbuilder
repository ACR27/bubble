json.array!(@interests) do |interest|
  json.extract! interest, :id, :user_id, :interest
  json.url interest_url(interest, format: :json)
end
