// ==============================================
// Commons settings for Consul
// ==============================================
log_level = "INFO"
disable_update_check = true
disable_host_node_id = true

// ==============================================
// Addresses & Ports
// See: https://developer.hashicorp.com/consul/docs/agent/config/config-files#advertise-address-parameters
// ==============================================
client_addr     = "0.0.0.0"
bind_addr       = "0.0.0.0" // or "{{ GetInterfaceIP \"eth0\" }}"
advertise_addr  = "{{ GetInterfaceIP \"eth0\" }}"

// ==============================================
// Server
// See: https://developer.hashicorp.com/consul/docs/agent/config/config-files#bootstrap-parameters
// ==============================================
server = true
bootstrap_expect = 3
retry_join = ["server", "server", "server"]
retry_max = 5 // By default, this is set to 0 which is interpreted as infinite retries
retry_interval = "30s" // Defaults to 30s
rejoin_after_leave = false
leave_on_terminate = true

// See: https://developer.hashicorp.com/consul/docs/agent/config/config-files#autopilot
autopilot {
    server_stabilization_time = "10s"
    last_contact_threshold = "200ms"
    max_trailing_logs = 250
    cleanup_dead_servers = true
}
