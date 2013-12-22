if platform?("windows")
  bin_path = node['watir::setup']['path']

  ruby_block "create watir path" do
    block do
      FileUtils.mkdir_p(bin_path) 
    end
    not_if { File.directory?(bin_path) }
  end
    
  windows_path "#{bin_path}" do
    action :add
  end

else
  Chef::Log.warn('This recipe only supports windows.')
end
