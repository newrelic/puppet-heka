# == Class: heka
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
class heka (
  $package_download_url = $heka::params::package_download_url,
  $manage_service       = $heka::params::manage_service,
  $service_ensure       = $heka::params::service_ensure,
  $service_enable       = $heka::params::service_enable,
  $heka_max_procs       = $heka::params::heka_max_procs,
  $heka_base_dir        = $heka::params::heka_base_dir,
  $heka_share_dir       = $heka::params::heka_share_dir
) inherits heka::params {

  case $::operatingsystem {
    'RedHat', 'CentOS': {
      $heka_daemon_name = 'heka'
      case $::operatingsystemmajrelease {
      #Pick Upstart for Red Hat/CentOS 6:
        '6': {
          
          package { 'heka':
            ensure   => 'installed',
            source   => $package_download_url,
            provider => $package_provider,
          } ->
  
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
            #notify  => Service[$heka_daemon_name],
          } ~>

          #File resource for /etc/init/heka.conf, the Upstart config file:
          file { '/etc/init/heka.conf':
            ensure  => 'file',
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('heka/heka.conf.erb'),
          } ~>

          service { $heka_daemon_name:
            ensure   => $service_ensure,
            provider => $service_provider,
            enable => $service_enable
          }
        }

        '7': {

          package { 'heka':
            ensure   => 'installed',
            source   => $package_download_url,
            provider => $package_provider,
          } ->
  
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
            #notify  => Service[$heka_daemon_name],
          } ~>

          #File resource for /usr/lib/systemd/system/heka.service, the systemd unit file
          #for the Heka daemon:
          file { '/usr/lib/systemd/system/heka.service':
            ensure  => 'file',
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('heka/heka.service.erb'),
          } ~>

          service { $heka_daemon_name:
            ensure   => $service_ensure,
            provider => $service_provider,
            enable => $service_enable
          }

        }
        default: { fail("${::operatingsystemmajrelease} is not a supported Red Hat/CentOS release!") }
      }
    }
    default: { fail("${::operatingsystem} is not a supported operating system!") }
  }

}