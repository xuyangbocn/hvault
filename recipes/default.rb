#
# Cookbook:: hvault
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

chef_gem 'vault' do
  compile_time true
end

read_vault 'Read secret at secret/hello' do
	path "secret/data/hello"
	address 'http://127.0.0.1:8200'
    token 's.u8FYJTVRLd2pEOfkykyffpSd'
    notifies :create, "file[/tmp/test.txt]", :immediately
end

file '/tmp/test.txt' do
	sensitive true
	content lazy {
	{ 
	:foo => node.run_state["secret/hello"].data[:data][:foo], 
	}
	action :nothing
end
