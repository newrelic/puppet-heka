# == Class: heka::install
#
# This class installs Heka via an RPM/DEB package.
#
# === Parameters
#
# @param package_download_url String; the URL of the RPM/DEB package to install; defaults to `$heka::params::package_download_url`
#
# === Examples
#
#  class { 'heka::install': }
#
# === Authors
#
# Nicholas Chappell <nchappell@newrelic.com>
#
# === Copyright
#
# Copyright 2015 Nicholas Chappell, unless otherwise noted.
class heka::install (
  $package_download_url = $heka::params::package_download_url,
) inherits heka::params {

  case $::operatingsystem {
    'RedHat', 'CentOS': {
      
      #Download the package first
      staging::file { 'heka-package':
        source => $package_download_url,
      } ~>

      package { 'heka':
        ensure   => 'installed',
        source   => '/opt/staging/heka/heka-package',
        provider => $package_provider,
      }
    }
    default: { fail("${::operatingsystem} is not a supported operating system!") }
  }

}