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

read_vault 'Read secret kv-v2/my-secret' do
	path "kv-v2/my-secret"
	address 'http://gcc.gov.sg:8200'
	token 's.aePrn5xtnNr7H2FaTkkNwR0C'
	notifies :create, "file[/tmp/test.txt]", :immediately
end

file '/tmp/test.txt' do
	sensitive true
	content lazy {
	"chef password is:#{node.run_state["kv-v2/my-secret"].data[:data][:password]}"
	}
	#action :nothing
end
