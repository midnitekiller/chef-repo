name "log_redis_server"
description "Redis database node for aggregating log lines."

run_list ["role[base]",
          "recipe[build-essential]",
          "recipe[redisio::install]",
          "recipe[redisio::enable]"
         ]
    
default_attributes(
  "redisio" =>         { "version" => '2.6.16',
                         "mirror"  => "http://download.redis.io/releases"
                       },

  "build_essential" => { "compiletime" => true 
                       }
)
