using OAuth, HTTP, JSON


oauth_consumer_key = "3APw4LnxlOgKzPoaa7EFwbOXZ"
oauth_consumer_secret = "oP9GrVUow2ivMsijrO0yxIhVhA2T4iltjeKPBaFbCbskeL1VN5"

oauth_token = "1207655773783769088-Ar8GUF6tkNe7tvZtvxzCgZ4IYivZWV"
oauth_token_secret = "TBqmc5bBzbrAeaNEpu1AfLqcbpF5IhKht9DF91vBgESKg"

post_url = "https://api.twitter.com/1.1/statuses/update.json"
retweet_url = "https://api.twitter.com/1.1/statuses/retweet/:id.json"
get_following = "https://api.twitter.com/1.1/statuses/home_timeline.json"

get_oauth(endpoint, options) = oauth_request_resource(endpoint, "GET", options, oauth_consumer_key, oauth_consumer_secret, oauth_token, oauth_token_secret)
tweet_oauth(endpoint, options) = oauth_request_resource(endpoint, "POST", options, oauth_consumer_key, oauth_consumer_secret, oauth_token, oauth_token_secret)


function tweet()
    abc = get_oauth(get_following, Dict("count" => "5"))
    jsonCode = String(abc.body)
    data = JSON.parse(jsonCode)
    for i in 1:5
        id = data[i]["id_str"]
        options = Dict("id" => "$id")
        retweet_url = "https://api.twitter.com/1.1/statuses/retweet/$id.json"
        mytweet = tweet_oauth(retweet_url, options)
    end
    # println("Tweet Status: ", mytweet.status)
end

tweet()