# == Defined type: heka::plugin
#
# This defined type is for creating Heka plugin TOML files
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
#  Coming soon...
#
# === Authors
#
# Nicholas Chappell <nchappell@newrelic.com>
#
# === Copyright
#
# Copyright 2015 Nicholas Chappell, unless otherwise noted.

define heka::plugin (
  $plugin_dir             = '/etc/heka',
  $plugin_dir_file_name   = "${name}.toml",
  $plugin_dir_file_ensure = file,
  $plugin_dir_file_owner  = 'root',
  $plugin_dir_file_group  = 'root',
  $plugin_dir_file_mode   = '0644',
  $refresh_heka_service   = true
  $plugin_file_template   = 'heka/heka_plugin.toml.erb'
  $plugin_settings        = {}


) inherits heka::params {

}