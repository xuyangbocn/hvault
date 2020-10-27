# Custom resource for reading a Vault secret
require 'vault'

resource_name :read_vault

# path : a String corresponding to the secret path in Vault (ex. 'kv/my-app')
# address: the address where the vault server is running (ex. 'http://127.0.0.1:8200')
# token : one of the ways to authenticate with Vault
# role_id: another way to authenticate with Vault. This assumes you have an approle created (https://www.vaultproject.io/docs/auth/approle.html)
property :path, String, required: true
property :address, String, required: true
property :token, String, required: true
property :role_name, String, required: false

action :read do
Vault.ssl_verify = false

# Need to set the vault address
Vault.address = new_resource.address

# Authenticate with the token
Vault.token = new_resource.token

if property_is_set?(:role_name) # Authenticate to Vault using the role_id
   approle_id = Vault.approle.role_id(new_resource.role_name)
   secret_id = (Vault.approle.create_secret_id(new_resource.role_name)).data[:secret_id]
   Vault.auth.approle(approle_id, secret_id)
end

# Attempt to read the secret
secret = Vault.logical.read(new_resource.path)
if secret.nil?
   raise "Could not read secret '#{new_resource.path}'!"
end

# Store the secret in memory only
node.run_state[new_resource.path] = secret

# Whether or not this resource was updated
# True = allows notifications to start
#updated_by_last_action(true)

end
