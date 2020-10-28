require 'vault'
require 'aws-sdk'

#
# Cookbook:: hvault
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

#chef_gem 'vault' do
#  compile_time true
#end

#hv = data_bag_item('secrets', 'hashi-vault')
#puts hv[:token]

Vault.configure do |config|
	# The address of the Vault server, also read as ENV["VAULT_ADDR"]
	config.address = "https://gcc.gov.sg:8200"
	config.ssl_verify = false
end

iam_role = 'gvt-iam-auth-role'
Vault.auth.aws_iam(iam_role, Aws::InstanceProfileCredentials.new, nil, 'https://sts.amazonaws.com', '/v1/auth/gcs-sm-ns-gvt-aws-auth/login')
# vault_token = Vault.auth.aws_ec2(iam_role, signature, nil) #"s.fs3SSbPSCmk7Q1yOqlN96Mee"

hvault_read_vault 'Read secret kv-v2/my-secret' do
	path "kv-v2/data/my-secret"
	address 'https://gcc.gov.sg:8200'
	token Vault.token
	notifies :create, "file[/tmp/test.txt]", :immediately
end

file '/tmp/test.txt' do
	sensitive true
	content lazy {
	"chef password is:#{node.run_state["kv-v2/data/my-secret"].data[:data][:password]}"
	}
	#action :nothing
end
