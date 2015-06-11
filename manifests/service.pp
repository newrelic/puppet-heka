# == Class: heka::service
#
# This class manages the Heka daemon as a regular service. It uses the Upstart or systemd
# init/unit files that are managed by the heka::config class.
#
# === Parameters
#
# @param service_ensure String; the state the Heka daemon should be set to; defaults to `running`
# @param service_enable Bool; whether the Heka daemon should be enabled to start on system boot; defaults to `true`
# @param heka_daemon_name String; the name of the Heka daemon; defaults to `heka` for both Red Hat/CentOS and Debian/Ubuntu
#
# === Authors
#
# Nicholas Chappell <nchappell@newrelic.com>
#

class heka::service (
  $service_ensure   = $heka::params::service_ensure,
  $service_enable   = $heka::params::service_enable,
  $heka_daemon_name = $heka::params::heka_daemon_name
) inherits heka::params {

  case $::operatingsystem {
    'RedHat', 'CentOS': {
      case $::operatingsystemmajrelease {
      #Pick Upstart for Red Hat/CentOS 6 and explicitly specify the start, stop, restart
      #and status commands as a workaround for bugs in the EL6 Upstart provider in older
      #versions of Puppet 3:
        '6': {
          service { $heka_daemon_name:
            ensure     => $service_ensure,
            provider   => $service_provider,
            enable     => $service_enable,
            hasrestart => true,
            hasstatus  => true,
            restart    => '/sbin/initctl restart heka',
            start      => '/sbin/initctl start heka',
            stop       => '/sbin/initctl stop heka',
            status     => '/sbin/initctl status heka | grep running',
          }
        }
        #CentOS 7 just uses systemd for the service provider, so we don't need any workarounds:
        '7': {
          service { $heka_daemon_name:
            ensure   => $service_ensure,
            provider => $service_provider,
            enable => $service_enable
          }
        }
        default: { fail("${::operatingsystemmajrelease} is not a supported Red Hat/CentOS release!") }
      }
    }
    'Debian', 'Ubuntu': {
      service { $heka_daemon_name:
        ensure   => $service_ensure,
        provider => $service_provider,
        enable => $service_enable
      }

    }
    default: { fail("${::operatingsystem} is not a supported operating system!") }
  }
}