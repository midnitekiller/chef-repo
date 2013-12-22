include_recipe "watir::setup"

if platform?("windows")
  bin_path = node['watir::setup']['path']

  windows_zipfile bin_path do
    source node['watir::ie']['http_url']
    action :unzip
    not_if {File.exists?(bin_path + "\\IEDriverServer.exe")}
  end

  registry_key "HKLM\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" do
    values [{
      :name => "IsInstalled",
      :type => :dword,
      :data => 00000000 
    }]
    action :create
  end

  # Disable IE Security enhanced mode
  registry_key "HKLM\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" do
    values [{
      :name => "IsInstalled",
      :type => :dword,
      :data => 00000000 
    }]
    action :create
  end

  execute "Make the reg changes appear right now" do
    command "Rundll32 iesetup.dll, IEHardenLMSettings"
    command "Rundll32 iesetup.dll, IEHardenUser"
    command "Rundll32 iesetup.dll, IEHardenAdmin"
  end

  # Disable IE Zone security protections
  registry_key "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\0" do
    values [{
      :name => "2500",
      :type => :dword,
      :data => 3
    }]
    action :create
  end
  
  registry_key "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\1" do
    values [{
      :name => "2500",
      :type => :dword,
      :data => 3
    }]
    action :create
  end

  registry_key "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\2" do
    values [{
      :name => "2500",
      :type => :dword,
      :data => 3
    }]
    action :create
  end

  registry_key "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\3" do
    values [{
      :name => "2500",
      :type => :dword,
      :data => 3
    }]
    action :create
  end

  registry_key "HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\4" do
    values [{
      :name => "2500",
      :type => :dword,
      :data => 3
    }]
    action :create
  end

else
  Chef::Log.warn('This recipe only supports windows.')
end
