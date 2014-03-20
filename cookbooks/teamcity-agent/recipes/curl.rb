if platform?("windows")

  curl_path = node["teamcity-agent::curl"]["curl_path"] 

  windows_zipfile curl_path do
    source node["teamcity-agent::curl"]["curl_url"]
    action :unzip
    not_if {::File.directory?(curl_path)}
  end

  windows_path "#{curl_path}\\bin" do
    action :add
  end

  # Moves contents from a path like C:\curl\curl-7.34.0-devel-mingw32 to C:\curl
  execute "move all curl versions to path" do
      command "cd #{curl_path} & cd c* & xcopy /s /e /q /c /y * .." 
  end

 
else
  Chef::Log.warn("Package can only be installed on the Windows platform using this cookbook.")
end

