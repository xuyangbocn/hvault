#
# Cookbook:: hvault
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

#chef_gem 'vault' do
#  compile_time true
#end

hv = data_bag_item('secrets', 'hashi-vault')
#puts hv[:token]

read_vault 'Read secret3 at secret/hello' do
	path "secret/data/hello"
	address 'http://127.0.0.1:8200'
    token hv[:token]
    notifies :create, "file[/tmp/test.txt]", :immediately
end

file '/tmp/test.txt' do
	sensitive true
	content lazy {
	"chef password is:#{node.run_state["secret/data/hello"].data[:data][:password]}"
	}
	#action :nothing
end