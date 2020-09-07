# Custom resource for reading a Vault secret
require 'json'
require 'vault'


path = "secret/hello"
address = "http://127.0.0.1:8200"
token = "s.iIlF6kKAzzumedqnRqNT57zN"

# Need to set the vault address
Vault.address = address

# Authenticate with the token
Vault.token = token

Vault.configure do |config|
	config.address = "http://127.0.0.1:8200"
	config.token = "s.iIlF6kKAzzumedqnRqNT57zN"
	config.ssl_verify = false
end

# Attempt to read the secret
secret = Vault.logical.read("secret/data/hello")
#if secret.nil?
#	raise "Could not read secret '#{new_resource.path}'!"
#end
puts secret.data[:data][:foo]
