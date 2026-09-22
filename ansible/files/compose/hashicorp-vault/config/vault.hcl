ui=true
disable_mlock=true

storage "raft" {
    path="/vault/data"
    node_id="vault-node-1"
}

listener "tcp" {
  address = "0.0.0.0:8200"

  tls_disable = 1
}

api_addr="https://vault.matejlab.duckdns.org"
cluster_addr = "https://vault-lab:8200"

telemetry {
    prometheus_retention_time = "30s"
    disable_hostname = false
}

user_lockout "all" {
    lockout_threshold = "5"
    lockout_duration = "10m"
    lockout_counter_reset = "10m"
    disable_lockout = false
}

default_lease_ttl = "168h"
max_lease_ttl = "720h"



