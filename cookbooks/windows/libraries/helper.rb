#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: windows
# Library:: helper
#
# Copyright:: 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'uri'

module Windows
  module Helper

    AUTO_RUN_KEY = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'.freeze unless defined?(AUTO_RUN_KEY)
    ENV_KEY = 'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'.freeze unless defined?(ENV_KEY)

    # returns windows friendly version of the provided path,
    # ensures backslashes are used everywhere
    def win_friendly_path(path)
      path.gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR) if path
    end

    # account for Window's wacky File System Redirector
    # http://msdn.microsoft.com/en-us/library/aa384187(v=vs.85).aspx
    # especially important for 32-bit processes (like Ruby) on a
    # 64-bit instance of Windows.
    def locate_sysnative_cmd(cmd)
      if ::File.exists?("#{ENV['WINDIR']}\\sysnative\\#{cmd}")
        "#{ENV['WINDIR']}\\sysnative\\#{cmd}"
      elsif ::File.exists?("#{ENV['WINDIR']}\\system32\\#{cmd}")
        "#{ENV['WINDIR']}\\system32\\#{cmd}"
      else
        cmd
      end
    end

    # Create a feature provider dependent value object.
    # mainly created becasue Windows Feature names are
    # different based on whether dism.exe or servicemanagercmd.exe
    # is used for installation
    def value_for_feature_provider(provider_hash)
      p = Chef::Platform.find_provider_for_node(node, :windows_feature)
      key = p.to_s.downcase.split('::').last
      provider_hash[key] || provider_hash[key.to_sym]
    end

    # singleton instance of the Windows Version checker
    def win_version
      @win_version ||= Windows::Version.new
    end

    # if a file is local it returns a windows friendly path version
    # if a file is remote it caches it locally
    def cached_file(source, checksum=nil, windows_path=true)
      @installer_file_path ||= begin

        if source =~ ::URI::ABS_URI && %w[http https].include?(URI.parse(source).scheme)
          uri = ::URI.parse(source)
          cache_file_path = "#{Chef::Config[:file_cache_path]}/#{::File.basename(uri.path)}"
          Chef::Log.debug("Caching a copy of file #{source} at #{cache_file_path}")
          r = Chef::Resource::RemoteFile.new(cache_file_path, run_context)
          r.source(source)
          r.backup(false)
          r.checksum(checksum) if checksum
          r.run_action(:create)
        else
          cache_file_path = source
        end

        windows_path ? win_friendly_path(cache_file_path) : cache_file_path
      end
    end

  end
end

Chef::Recipe.send(:include, Windows::Helper)
