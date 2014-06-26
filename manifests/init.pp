# = Class: bind
#
# Module to manage bind
#
# == Requirements:
#
# - This module makes use of the example42 functions in the puppi module
#   (https://github.com/credativ/puppet-example42lib)
#
# == Parameters:
#
# [*ensure*]
#   What state to ensure for the package. Accepts the same values
#   as the parameter of the same name for a package type.
#   Default: present
#   
# [*ensure_running*]
#   Weither to ensure running bind or not.
#   Default: running
#
# [*ensure_enabled*]
#   Weither to ensure that bind is started on boot or not.
#   Default: true
#   
# [*manage_config*]
#   Weither to manage bind configuration files at all or not.
#
# [*config_source*]
#   Specify a configuration source for the configuration. If this
#   is specified it is used instead of a emplate-generated configuration
#
# [*config_template*]
#   Override the default choice for the configuration template
#
# [*disabled_hosts*]
#   A list of hosts whose bind will be disabled, if their
#   hostname matches a name in the list.
#
class bind (
    $ensure             = params_lookup('ensure'),
    $ensure_running     = params_lookup('ensure_running'),
    $ensure_enabled     = params_lookup('ensure_enabled'),
    $manage_config      = params_lookup('managed_config'),
    $disabled_hosts     = params_lookup('disabled_hosts'),
    $listener           = params_lookup('listener'),
    $forwarders         = params_lookup('forwarders'),

    ) inherits bind::params {

    Package['bind9'] -> File['/etc/bind/named.conf.options'] 
        -> Service['bind9']

    package { 'bind9':
        ensure => $ensure,
        alias  => 'bind'
    }

    service { 'bind9':
        ensure      => $ensure_running,
        enable      => $ensure_enabled,
        hasrestart  => true,
        hasstatus   => true,
        require     => Package['bind9']
    }

    if $manage_config {
        file { '/etc/bind/named.conf.options':
            mode        => '0644',
            owner       => 'root',
            group       => 'root',
            content     => template('bind/named.conf.options.erb'),
            notify      => Service['bind9']
        }
    }

    # Disable service on this host, if hostname is in disabled_hosts
    if $::hostname in $disabled_hosts {
        Service <| title == 'bind' |> {
            ensure  => 'stopped',
            enabled => false,
        }
    }
}

