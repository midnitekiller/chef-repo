name "teamcity_agent_linux"
description "TeamCity continuous integration build agent."

run_list ["role[base]",
          "recipe[rvm::system]",                 # Install RVM and ruby
          "recipe[rvm::gem_package]",            # Patch gem_package to use RVM
          "recipe[java::oracle]",                # TeamCity doesn't like OpenJDK 
          "recipe[nodejs]",                      # Node.js (only for its JS runtime)
          #"recipe[mysql::client]",              # MySQL client
          "recipe[postgresql::client]",          # PostgreSQL client
          "recipe[ocean::libcurl4_openssl_dev]", # For Typhoeus
          "recipe[zeromq]",                      # ZeroMQ for tests
          "recipe[ocean::fake_dynamo]",          # Install and run fake_dynamo for AWS DynamoDB testing
          "recipe[teamcity-agent::linux]"
         ]
    
default_attributes(

  "java" => {
    "jdk_version" => "7",
    "jdk" => { 
      "7" => { 
        "x86_64" => { "url" => 'http://uni-smr.ac.ru/archive/dev/java/SDKs/sun/j2se/7/jdk-7u45-linux-x64.tar.gz' }
      }
    }
  },

  "build_essential" => { "compiletime" => true },
  "rvm" => {
    "rvmrc" => {
      "rvm_project_rvmrc" => 1,
      "rvm_gemset_create_on_use_flag" => 1,
      "rvm_trust_rvmrcs_flag" => 1
    },
    "global_gems" => [{ 'name' => 'bundler' },
                      { 'name' => 'fake_dynamo', 'version' => '0.1.3' }],
    "user_global_gems" => [{ 'name' => 'bundler' },
                           { 'name' => 'fake_dynamo', 'version' => '0.1.3' }]
  },

  'postgresql' => {
    'version' => "9.3"
  }

)
