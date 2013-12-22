define :ocean_install_missing_ubuntu_libs do
	
  ["libxslt-dev", "libxml2-dev"].each do |p|
    package p do
      action :install
    end
  end

end
