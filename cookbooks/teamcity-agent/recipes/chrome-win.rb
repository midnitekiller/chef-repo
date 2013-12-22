if platform?("windows")
    windows_package "Chrome" do
        source node['teamcity-agent::chrome-win']['http_url']
        action :install
    end
else
  Chef::Log.warn('Chrome can only be installed on the Windows platform using this cookbook.')
end

