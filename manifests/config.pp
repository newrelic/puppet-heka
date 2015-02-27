# == Class: heka::config
#
# Full description of class heka here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'heka': }
#
# === Authors
#
# Nicholas Chappell <nchappell@newrelic.com>
#
# === Copyright
#
# Copyright 2015 Nicholas Chappell, unless otherwise noted.
class heka::config (
  $heka_daemon_name = $heka::params::heka_daemon_name,
) inherits heka::params {

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
    default: { fail("${::operatingsystem} is not a supported operating system!") }
  }

}