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
  $package_download_url = $heka::params::package_download_url
  $manage_service       = $heka::params::manage_service
  $service_ensure       = $heka::params::service_ensure
  $heka_max_procs       = $heka::params::heka_max_procs
  $heka_base_dir        = $heka::params::heka_base_dir
  $heka_share_dir       = $heka::params::heka_share_dir
) inherits heka::params {

}