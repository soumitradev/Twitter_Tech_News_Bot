using OAuth, HTTP, JSON

# Set basic variables for authentication
oauth_consumer_key = ENV["OAUTH_CONSUMER_KEY"]
oauth_consumer_secret = ENV["OAUTH_CONSUMER_SECRET"]

oauth_token = ENV["OAUTH_TOKEN"]
oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]

# All the API URLs to call for various GET and POST requests
retweet_url = "https://api.twitter.com/1.1/statuses/retweet/:id.json"
get_following = "https://api.twitter.com/1.1/statuses/home_timeline.json"

# Number of tweets to get every 5 minutes
# I'm using just below Twitter's limit
# News is fast, and the bot should keep pace.
number_of_tweets = 14

# Words that determine if a tweet is considered news
trigger_words = ["now", "new", "latest", "see", "update", "feature", "check", "announce", "announcing", "announced", "today", "unveil", "introducing", "release"]

# GET and POST functions
get_oauth(endpoint, options) = oauth_request_resource(endpoint, "GET", options, oauth_consumer_key, oauth_consumer_secret, oauth_token, oauth_token_secret)
tweet_oauth(endpoint, options) = oauth_request_resource(endpoint, "POST", options, oauth_consumer_key, oauth_consumer_secret, oauth_token, oauth_token_secret)

# Our main function
function tweet()

    # GET the 10 most recent tweest in the last 15 minutes
    tweets = get_oauth(get_following, Dict("count" => "$number_of_tweets"))

    # Convert HTTP request to JSON and process it
    jsonCode = String(tweets.body)
    data = JSON.parse(jsonCode)

    # List of tweets
    acquired_tweets = []

    # Check if each tweet is considered news, and append its id to the list of tweets if it is news
    for i in 1:length(data)
        id = data[i]["id_str"]
        for trigger_word in trigger_words
            if occursin(trigger_word, lowercase(data[i]["text"]))
                push!(acquired_tweets, id)
            end
        end
    end

    # For every new tweet, retweet the tweet using its id.
    for j in 1:length(acquired_tweets)
    # If a 403 error is returned, ignore it and move on to the next tweet
    # This happens when we try to tweet a tweet that has already been retweeted by us.
        try
            id = acquired_tweets[j]
            options = Dict("id" => "$id")
            retweet_url = "https://api.twitter.com/1.1/statuses/retweet/$id.json"
            mytweet = tweet_oauth(retweet_url, options)
        catch
            continue
        end
    end
end

tweet()
