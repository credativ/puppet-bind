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
# [* ensure *]
#   What state to ensure for the package. Accepts the same values
#   as the parameter of the same name for a package type.
#   Default: present
#   
# [* ensure_running *]
#   Weither to ensure running bind or not.
#   Default: running
#
# [* ensure_enabled *]
#   Weither to ensure that bind is started on boot or not.
#   Default: true
#
# [* config_source *]
#   Specify a configuration source for the configuration. If this
#   is specified it is used instead of a emplate-generated configuration
#
# [* config_template *]
#   Override the default choice for the configuration template
#
# [* disabled_hosts *]
#   A list of hosts whose bind will be disabled, if their
#   hostname matches a name in the list.
#

class bind (
    $ensure             = params_lookup('ensure'),
    $ensure_running     = params_lookup('ensure_running'),
    $ensure_enabled     = params_lookup('ensure_enabled'),
    $disabled_hosts     = params_lookup('disabled_hosts'),
    $listener           = params_lookup('listener'),
    $forwarders         = params_lookup('forwarders'),

    ) inherits bind::params {

    package { 'bind9':
        ensure => $ensure,
        alias  => 'bind'
    }

    service { 'bind9':
        ensure      => $ensure_running,
        enable      => $ensure_enabled,
        hasrestart  => true,
        hasstatus   => true,
        alias       => 'bind',
        require     => Package['bind']
    }

    file { '/etc/bind/named.conf.options':
        alias       => 'bind_options'
        mode        => '0644',
        owner       => 'root',
        group       => 'root',
        content     => template('bind/named.conf.options.erb'),
        notify      => Service['bind']
    }

    # Disable service on this host, if hostname is in disabled_hosts
    if $::hostname in $disabled_hosts {
        Service <| title == 'bind' |> {
            ensure  => 'stopped',
            enabled => false,
        }
    }

    if $config_source {
        File <| tag == 'bind_config' |> {
            source  => $config_source
        }
    } elsif $config_template {
        File <| tag == 'bind_config' |> {
            template => $config_template
        }
    }
}

