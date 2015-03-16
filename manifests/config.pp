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
  $heka_daemon_name       = $heka::params::heka_daemon_name,
  $global_config_settings = $heka::params::global_config_settings,
) inherits heka::params {

  #Do some validation of the class' parameters:
  validate_hash($global_config_settings)

  #Manage /etc/heka/
  file {'/etc/heka':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
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