json.array!(@tweets) do |tweet|
  json.extract! tweet, :id, :text, :name, :time, :twitter_id
  json.url tweet_url(tweet, format: :json)
end
