$redis = Redis::Namespace.new("tweets", :redis => Redis.new)
