require 'vault'

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

signature = `curl http://169.254.169.254/latest/dynamic/instance-identity/pkcs7`
iam_role = `curl http://169.254.169.254/latest/meta-data/iam/security-credentials/`
vault_token = Vault.auth.aws_ec2(iam_role, signature, nil) #"s.C0mnpOzkC2hDz9NJgZWSIyXp"

hvault_read_vault 'Read secret kv-v2/my-secret' do
	path "kv-v2/data/my-secret"
	address 'https://gcc.gov.sg:8200'
	token "#{vault_token}"
	notifies :create, "file[/tmp/test.txt]", :immediately
end

file '/tmp/test.txt' do
	sensitive true
	content lazy {
	"chef password is:#{node.run_state["kv-v2/data/my-secret"].data[:data][:password]}"
	}
	#action :nothing
end
