# == Class: heka::install
#
# This class installs Heka via an RPM/DEB package.
#
# === Parameters
#
# @param package_download_url String; the URL of the RPM/DEB package to install; defaults to `$heka::params::package_download_url`
# @param version String; the version of Heka being installed; right now, this is just used to create unique file names for each package version that gets downloaded and to reference it in the package resource that installs Heka
#
# === Examples
#
#  class { 'heka::install': }
#
# === Authors
#
# Nicholas Chappell <nchappell@newrelic.com>
#

class heka::install (
  $package_download_url = $heka::params::package_download_url,
  $version = $heka::params::version,
) inherits heka::params {

  case $::operatingsystem {
    'RedHat', 'CentOS': {
      #Download the package first
      staging::file { "heka-package_${version}.rpm":
        source => $package_download_url,
      } ~>
      #...then install it:
      package { 'heka':
        ensure   => 'latest',
        source   => "/opt/staging/heka/heka-package_${version}.rpm",
        provider => $package_provider,
      }
    }
    'Debian', 'Ubuntu': {
      #Download the package first
      staging::file { "heka-package_${version}.deb":
        source => $package_download_url,
      } ~>
      #...then install it:
      package { 'heka':
        ensure   => 'latest',
        source   => "/opt/staging/heka/heka-package_${version}.deb",
        provider => $package_provider,
      }
    }
    default: { fail("${::operatingsystem} is not a supported operating system!") }
  }

}