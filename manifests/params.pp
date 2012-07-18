class bind::params {
    $ensure         = 'present'
    $ensure_running = true
    $ensure_enabled = true
    $disabled_hosts = []
    $listener       = undef
    $forwarders     = undef
}

