if platform?("windows")
 
  zmq_bin_path = node['teamcity-agent::zeromq-win']['bin_path'] 
  zmq_lib_name = node['teamcity-agent::zeromq-win']['lib_name']  

  windows_package "ZeroMQ" do
    source node['teamcity-agent::zeromq-win']['binary_url']
    installer_type :nsis # One of :msi, :inno, :nsis, :wise, :installshield, or :custom
    action :install
  end

  ruby_block "rename libzmq.dll" do
    block do
        FileUtils.cp("#{zmq_bin_path}\\#{zmq_lib_name}","#{node['teamcity-agent::ruby-win']['ruby_path']}\\bin\\libzmq.dll") 
    end
  end

  windows_path zmq_bin_path do
    action :add
  end

else
  Chef::Log.warn('This package can only be installed on the Windows platform using this cookbook.')
end


