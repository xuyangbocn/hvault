resource_name :vault_secret

property :path, String, name_property: true
property :destination, String

action :read do
  destination ||= path
  lease_id = node[destination]

  begin
    # Attempt to renew the lease.
    Vault.sys.renew(lease_id)

    # If the renew succeeded, do not fire notifications because the secret is
    # already persisted on the notified resource(s).
    updated_by_last_action(false)

    # Done
    return
  rescue Vault::HTTPClientError => e
    # Renewal failed - this could mean that the lease has been manually
    # revoked or we did not renew in time. In any case, we will log a message
    # and attempt to read a new secret.
    Chef::Log.warn("Failed to renew `#{lease_id}', attempting a fresh read")
  end if lease_id

  # Attempt to read the secret. If this fails, an error is raised.
  secret = Vault.logical.read(path)
  if secret.nil?
    raise "Could not read secret `#{path}'!"
  end

  # If the secret is renewable, save the lease_id so we can renew it later.
  if secret.renewable?
    node.set[destination] = secret.lease_id
  end

  # Persist the secret in-memory for the rest of this Chef run.
  node.run_state[destination] = secret

  # Tell notifications to fire.
  updated_by_last_action(true)
end
