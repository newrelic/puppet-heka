# == Class: heka
#
# This is the main class of the module. It calls the ::install, ::config and ::service classes.
#
# === Parameters
#
# @param package_download_url String; the URL of the RPM/DEB package to install.
# @param version String; the version of Heka being installed; right now, this is just used to create unique file names for each package version that gets downloaded and to reference it in the package resource that installs Heka
# @param manage_service Bool; whether to have the module manage the Heka daemon. defaults to `true`
# @param service_ensure String; the state the Heka daemon should be set to; defaults to `running`
# @param service_enable Bool; whether the Heka daemon should be enabled to start on system boot; defaults to `true`
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

class heka (
  $package_download_url   = $heka::params::package_download_url,
  $version                = $heka::params::version,
  $manage_service         = $heka::params::manage_service,
  $service_ensure         = $heka::params::service_ensure,
  $service_enable         = $heka::params::service_enable,
  $global_config_settings = $heka::params::global_config_settings,
) inherits heka::params {

  #Do some validation of the class' parameters:
  validate_hash($global_config_settings)

  if $manage_service == true {
    #Apply our classes in the right order. Use the squiggly arrows (~>) to ensure that the
    #class left is applied before the class on the right and that it also refreshes the
    #class on the right.
    class { 'heka::install':
      package_download_url => $package_download_url,
      version => $version,
    } ~>
    class { 'heka::config': 
      global_config_settings => $global_config_settings
    } ~>
    class { 'heka::service': }
  }
  else {
    #Like the class chain above, but without the `class { 'heka::service': }`.
    class { 'heka::install':
      package_download_url => $package_download_url,
      version => $version,
    } ~>
    class { 'heka::config': }
  }

}