# == Class: heka::params
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
# === Parameters
#
# Coming soon...
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

class heka::params {

  ##############################
  # Heka general parameters
  ##############################

  #Parameter for the maxprocs in the [hekad] section of a heka.toml file; defaults to 1 (integer)
  $heka_max_procs = 1
  #Parameter for the base_dir in the [hekad] section of a heka.toml file; defaults to '/var/cache/hekad' (string)
  $heka_base_dir = '/var/cache/hekad'
  #Parameter for the share_dir in the [hekad] section of a heka.toml file; defaults to '/usr/share/heka' (string)
  $heka_share_dir = '/usr/share/heka'
  
  ##############################
  # Heka package parameters
  ##############################
  
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

  $package_ensure = 'installed'


  ##############################
  # Heka service parameters
  ##############################
  
  #Whether the daemon should be running; defaults to 'running'
  $service_ensure = 'running'

  #Pick the right daemon name based on the operating system; it's the same across
  #RedHat/CentOS and Debian/Ubuntu right now, but we're keeping them separate in case they
  #change in the future:
  case $::operatingsystem {
    #RedHat/CentOS systems:
    'RedHat', 'CentOS': {
      $heka_daemon_name = 'rpm'
    }
    #Debian/Ubuntu systems:
    'Debian', 'Ubuntu': {
     #Pick the right package provider:
      $package_provider = 'dpkg'
      $package_download_name = 'heka_0.8.3_amd64.deb'
    }
    default: { fail("${::operatingsystem} is not a supported operating system!") }
  }



}