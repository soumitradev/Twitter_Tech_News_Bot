using OAuth, HTTP, JSON

oauth_consumer_key = "3APw4LnxlOgKzPoaa7EFwbOXZ"
oauth_consumer_secret = "oP9GrVUow2ivMsijrO0yxIhVhA2T4iltjeKPBaFbCbskeL1VN5"

oauth_token = "1207655773783769088-Ar8GUF6tkNe7tvZtvxzCgZ4IYivZWV"
oauth_token_secret = "TBqmc5bBzbrAeaNEpu1AfLqcbpF5IhKht9DF91vBgESKg"

post_url = "https://api.twitter.com/1.1/statuses/update.json"
retweet_url = "https://api.twitter.com/1.1/statuses/retweet/:id.json"
get_following = "https://api.twitter.com/1.1/statuses/home_timeline.json"

number_of_tweets = 10
# Number of tweets to get every 15 minutes
trigger_words = ["now", "new", "latest", "see", "update", "feature", "check", "announce", "announcing", "announced", "today", "unveil", "introducing", "release"]

get_oauth(endpoint, options) = oauth_request_resource(endpoint, "GET", options, oauth_consumer_key, oauth_consumer_secret, oauth_token, oauth_token_secret)
tweet_oauth(endpoint, options) = oauth_request_resource(endpoint, "POST", options, oauth_consumer_key, oauth_consumer_secret, oauth_token, oauth_token_secret)

function tweet()
    retweeted_ids = JSON.parse(string(read("tweeted.json", String)))

    tweets = get_oauth(get_following, Dict("count" => "$number_of_tweets"))
    jsonCode = String(tweets.body)
    data = JSON.parse(jsonCode)
    acquired_tweets = []
    for i in 1:number_of_tweets
        id = data[i]["id_str"]
        if id in retweeted_ids
            continue
        end
        for trigger_word in trigger_words
            if occursin(trigger_word, lowercase(data[i]["text"]))
                push!(acquired_tweets, id)
            end
        end
    end

    open("tweeted.json", "w+") do io
        write(io, JSON.json(union(retweeted_ids, acquired_tweets)))
    end;

    for j in 1:length(acquired_tweets)
        id = acquired_tweets[j]
        options = Dict("id" => "$id")
        retweet_url = "https://api.twitter.com/1.1/statuses/retweet/$id.json"
        mytweet = tweet_oauth(retweet_url, options)
    end
end

tweet()