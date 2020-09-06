#
# Cookbook:: hvault
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.


read_vault 'Read secret at secret/hello' do
	path "secret/data/hello"
	address 'http://127.0.0.1:8200'
	token '96d0a802-fd00-5b57-87b4-0b15ed2dbe3c'
	role_name 'chef-role'
	notifies :create, "template[/etc/my-app/config]", :immediately
end

template '/etc/my-app/config' do
	source 'my-app.conf'
	mode '0600'
	sensitive true
	variables lazy {
	{ 
	:username => node.run_state["secret/hello"].data[:data][:foo], 
	:password => node.run_state["secret/hello"].data[:data][:bar],
	}
	action :nothing
end
