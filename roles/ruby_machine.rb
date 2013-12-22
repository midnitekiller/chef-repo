name "ruby_machine"
description "Installs RVM and default rubies."

run_list ["recipe[build-essential]",
          "recipe[ruby-src]"
]

override_attributes(
  
  "build_essential" => { 
    "compiletime" => true 
  }

)
