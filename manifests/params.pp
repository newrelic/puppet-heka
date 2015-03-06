# == Class: heka::params
#
# This class contains parameters used by other subclasses in the module.
#
# === Parameters
#
# This class doesn't have any settable parameters. It provides parameters to other classes.
#
# === Authors
#
# Nicholas Chappell <nchappell@newrelic.com>
#
# === Copyright
#
# Copyright 2015 Nicholas Chappell, unless otherwise noted.

class heka::params {

  ##############################
  # Heka general parameters
  ##############################

  #Parameter for the maxprocs in the [hekad] section of a heka.toml file; defaults to 1 (integer)
  $heka_max_procs = $::processorcount
  #Parameter for the base_dir in the [hekad] section of a heka.toml file; defaults to '/var/cache/hekad' (string)
  $heka_base_dir = '/var/cache/hekad'
  #Parameter for the share_dir in the [hekad] section of a heka.toml file; defaults to '/usr/share/heka' (string)
  $heka_share_dir = '/usr/share/heka'
  
  ##############################
  # Heka package parameters
  ##############################

  $package_ensure = 'installed'
  
  case $::operatingsystem {
    #Red Hat and CentOS systems:
    'RedHat', 'CentOS': {
     #Pick the right package provider:
      $package_provider = 'rpm'
      $package_download_url = 'https://github.com/mozilla-services/heka/releases/download/v0.8.3/heka-0_8_3-linux-amd64.rpm'
    }
    #Debian/Ubuntu systems:
    'Debian', 'Ubuntu': {
     #Pick the right package provider:
      $package_provider = 'dpkg'
      $package_download_url = 'https://github.com/mozilla-services/heka/releases/download/v0.8.3/heka_0.8.3_amd64.deb'
    }
  }

  ##############################
  # Heka service parameters
  ##############################
  
  #Whether the daemon should be running; defaults to 'running'
  $manage_service = true
  $service_ensure = 'running'
  $service_enable = true

  #Pick the right daemon name based on the operating system; it's the same across
  #RedHat/CentOS and Debian/Ubuntu right now, but we're keeping them separate in case they
  #change in the future.
  #Also pick the right service manager. On Debian/Ubuntu and RedHat/CentOS 6.x, it should be
  #Upstart. On RedHat/CentOS 7, it should be systemd:
  case $::operatingsystem {
    'RedHat', 'CentOS': {
      $heka_daemon_name = 'heka'
      case $::operatingsystemmajrelease {
      #Pick Upstart for Red Hat/CentOS 6:
        '6': {
          $service_provider = 'upstart'
        }
        #Pick systemd for Red Hat/CentOS 7:
        '7': {
          $service_provider = 'systemd'
        }
        default: { fail("${::operatingsystemmajrelease} is not a supported Red Hat/CentOS release!") }
      }
    }
    #Debian/Ubuntu systems:
    'Debian', 'Ubuntu': {
     #Pick the right package provider:
      $heka_daemon_name = 'heka'
      $service_provider = 'upstart'
    }
    default: { fail("${::operatingsystem} is not a supported operating system!") }
  }

}