# hvault

TODO: Enter the cookbook description here.

# hvault
Preparation Steps:
1. Start Hashicorp Vault server
$ vault server -dev
==> Vault server configuration:

             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.14.7
...

2. Set Environment variables to connect to Vault
`$ export VAULT_ADDR='http://127.0.0.1:8200'`
`$ export VAULT_OKEN='s.u8FYJTVRLd2pEOfkykyffpSd'`


3. Create a secret in Hashicorp Vault
`$ vault kv put secret/hello password=Ch3fR0cks`
`$ vault kv get secret/hello`


4. You can hardcode the value of VAULT_TOKEN in the recipe, `read_vault` resource.  A better way is to use data bag to store the token.

`$ cat ./hashi-vault.json`
`{
"id": "hashi-vault",
"token": "s.u8FYJTVRLd2pEOfkykyffpSd"
}`

`$ knife data bag from file secrets ./hashi-vault.json`
Updated data_bag_item[secrets::hashi-vault]

`$ knife data bag create secrets hashi-vault`
id:    hashi-vault
token: s.u8FYJTVRLd2pEOfkykyffpSd

