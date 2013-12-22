name "teamcity_agent_windows"
description "TeamCity continuous integration build agent."

run_list ["recipe[ocean]",
          "recipe[windows]",
          "recipe[java]",             # TeamCity doesn"t like OpenJDK 
          "recipe[7-zip-master]",
          "recipe[teamcity-agent::ruby-win]",
          "recipe[teamcity-agent::ruby-devkit-win]",
          "recipe[teamcity-agent::bundler-win]",
          "recipe[ms-cpp-redistributable::2008_x86]", # needed for zeromq dll
          "recipe[teamcity-agent::zeromq-win]",
          "recipe[teamcity-agent::windows]",
          "recipe[teamcity-agent::firefox-win]",
          "recipe[teamcity-agent::chrome-win]",
          "recipe[teamcity-agent::safari-win]",
          "recipe[watir::ie]",
          "recipe[watir::chrome]",
         ]

default_attributes(
  "java" => {
    "jdk_version" => "7",
    "windows" => {
      "package_name" => "jdk_7",
      "url" => "http://uni-smr.ac.ru/archive/dev/java/SDKs/sun/j2se/7/jdk-7u45-windows-x64.exe" 
    }
  },
  "build_essential" => { "compiletime" => true },
  "teamcity-agent" => { "java_path" => "C:\\Program Files\\Java\\jdk1.7.0_45\\jre\\bin\\java" },
  "windows" => { "rubyzipversion" => "1.1.0" }
)
