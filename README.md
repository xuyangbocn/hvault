# hvault

TODO: Enter the cookbook description here.

# hvault
PREPARATION:
0. Start Hashicorp Vault server
$ vault server -dev
==> Vault server configuration:

             Api Address: http://127.0.0.1:8200
                     Cgo: disabled
         Cluster Address: https://127.0.0.1:8201
              Go Version: go1.14.7
...

1. Set Environment Variables to connect to Vault
$ export VAULT_ADDR='http://127.0.0.1:8200'
$ export VAULT_TOKEN='s.u8FYJTVRLd2pEOfkykyffpSd'

2. Create secret in Hashicorp Vault
$ vault kv put secret/hello password=Ch3fR0cks

$ vault kv get secret/hello

3. If you want to use data bag to store VAULT_TOKEN do the followings, otherwise just hardcode the value of token in the read_vault resource.
# use the appropriate token
$ cat ./hashi-vault.json
{
"id": "hashi-vault",
"token": "s.u8FYJTVRLd2pEOfkykyffpSd"
}

$ knife data bag from file secrets ./hashi-vault.json
Updated data_bag_item[secrets::hashi-vault]

$ knife data bag create secrets hashi-vault
id:    hashi-vault
token: s.u8FYJTVRLd2pEOfkykyffpSd

