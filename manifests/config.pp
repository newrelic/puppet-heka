# == Class: heka::config
#
# This class handles general, non-plugin configuration of Heka. Currently, it manages the
# Upstart init file or systemd unit file for Heka so Puppet can manage the Heka daemon as
# a regular service. It also manages the directory `/etc/heka` and the file `/etc/heka.toml`.
#
# === Parameters
#
# @param heka_daemon_name String; the name of the Heka daemon; defaults to `heka` for both Red Hat/CentOS and Debian/Ubuntu
# @param global_config_settings Hash; a hash of global Heka config options; defaults to an empty hash, `{}`
# @param purge_unmanaged_configs Bool; whether to purge unmanaged Heka TOML config files that are not managed by Puppet; defaults to true
#
# === Examples
#
#  class { 'heka': }
#
# === Authors
#
# Nicholas Chappell <nchappell@newrelic.com>
#

class heka::config (
  $heka_daemon_name        = $heka::params::heka_daemon_name,
  $global_config_settings  = $heka::params::global_config_settings,
  $manage_service          = $heka::params::manage_service,
  $purge_unmanaged_configs = $heka::params::purge_unmanaged_configs,
  $heka_max_procs          = $heka::params::heka_max_procs,
  $cgroup_memory_limit     = $heka::cgroup_memory_limit,
) inherits heka::params {

  #Do some validation of the class' parameters:
  validate_hash($global_config_settings)

  if $manage_service == true {
    #Manage /etc/heka/
    file {'/etc/heka':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      purge   => $purge_unmanaged_configs,
      recurse => $purge_unmanaged_configs,
    } ~>

    #Manage /etc/heka/heka.toml
    file {'/etc/heka/heka.toml':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('heka/heka.toml.erb'),
      notify  => Service[$heka_daemon_name],
    }

    case $::operatingsystem {
      'RedHat', 'CentOS': {
        case $::operatingsystemmajrelease {
        #Pick Upstart for Red Hat/CentOS 6:
          '6': {
            #File resource for /etc/init/heka.conf, the Upstart config file:
            file { '/etc/init/heka.conf':
              ensure  => 'file',
              owner   => 'root',
              group   => 'root',
              mode    => '0644',
              content => template('heka/heka.conf.erb'),
              notify  => Service[$heka_daemon_name],
            } ~>
            #Run initctl reload-configuration so Upstart knows about the new Heka daemon config file:
            exec { 'initctl-reload-config-for-heka':
              command     => "/sbin/initctl reload-configuration",
              refreshonly => true,
            }
          }
          '7': {
            #File resource for /usr/lib/systemd/system/heka.service, the systemd unit file
            #for the Heka daemon:
            file { '/usr/lib/systemd/system/heka.service':
              ensure  => 'file',
              owner   => 'root',
              group   => 'root',
              mode    => '0644',
              content => template('heka/heka.service.erb'),
              notify  => Service[$heka_daemon_name],
            } ~>
            exec { 'systemd_reload_unit_files':
              user        => 'root',
              command     => '/usr/bin/systemctl daemon-reload',
              refreshonly => true,
              require     => File['/usr/lib/systemd/system/heka.service'],
            }
          }
          default: { fail("${::operatingsystemmajrelease} is not a supported Red Hat/CentOS release!") }
        }
      }
      'Debian', 'Ubuntu': {
          #File resource for /etc/init/heka.conf, the Upstart config file:
          file { '/etc/init/heka.conf':
            ensure  => 'file',
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('heka/heka.conf.erb'),
            notify  => Service[$heka_daemon_name],
          }
       }
      default: { fail("${::operatingsystem} is not a supported operating system!") }
    }
  }

  else {
    #Manage /etc/heka/
    file {'/etc/heka':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      purge   => $purge_unmanaged_configs,
      recurse => $purge_unmanaged_configs,
    } ~>

    #Manage /etc/heka/heka.toml
    file {'/etc/heka/heka.toml':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('heka/heka.toml.erb'),
    }

    case $::operatingsystem {
      'RedHat', 'CentOS': {
        case $::operatingsystemmajrelease {
        #Pick Upstart for Red Hat/CentOS 6:
          '6': {
            #File resource for /etc/init/heka.conf, the Upstart config file:
            file { '/etc/init/heka.conf':
              ensure  => 'file',
              owner   => 'root',
              group   => 'root',
              mode    => '0644',
              content => template('heka/heka.conf.erb'),
            }
          }
          '7': {
            #File resource for /usr/lib/systemd/system/heka.service, the systemd unit file
            #for the Heka daemon:
            file { '/usr/lib/systemd/system/heka.service':
              ensure  => 'file',
              owner   => 'root',
              group   => 'root',
              mode    => '0644',
              content => template('heka/heka.service.erb'),
            } ~>
            exec { 'systemd_reload_unit_files':
              user        => 'root',
              command     => '/usr/bin/systemctl daemon-reload',
              refreshonly => true,
              require     => File['/usr/lib/systemd/system/heka.service'],
            }
          }
          default: { fail("${::operatingsystemmajrelease} is not a supported Red Hat/CentOS release!") }
        }
      }
       'Debian', 'Ubuntu': {
          #File resource for /etc/init/heka.conf, the Upstart config file:
          file { '/etc/init/heka.conf':
            ensure  => 'file',
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('heka/heka.conf.erb'),
          }
       }
      default: { fail("${::operatingsystem} is not a supported operating system!") }
    }
  }

}
