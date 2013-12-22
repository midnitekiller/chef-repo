include_recipe "watir::setup"

if platform?("windows")
  bin_path = node['watir::setup']['path']

  windows_zipfile bin_path do
    source node['watir::chrome']['http_url']
    action :unzip
    not_if {File.exists?(bin_path + "\\chromedriver.exe")}
  end
else
  Chef::Log.warn('This recipe only supports windows.')
end
