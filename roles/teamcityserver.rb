name "teamcityserver"
description "TeamCity continuous integration server."

run_list ["role[base]",
          "recipe[java::oracle]"  # TeamCity doesn't like OpenJDK 
         ]
    
default_attributes(
  "java" => {
    "jdk_version" => "7",
    "jdk" => { 
      "7" => { 
        "x86_64" => { "url" => 'http://uni-smr.ac.ru/archive/dev/java/SDKs/sun/j2se/7/jdk-7u45-linux-x64.tar.gz' }
      }
    }
  }
)

# override_attributes(
#   "authorization" => {
#     "sudo" => {
#       "groups"       => ["sysadmin"],
#       "passwordless" => true
#     }
#   }
# )
