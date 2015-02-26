# == Defined type: heka::plugin::input::tcpinput
#
# This defined type is for creating custom Heka TOML plugin files.
#
# === Parameters
#
# @param plugin_dir String; the directory the TOML plugin file will be created in; defaults to `/etc/heka`.
# @param plugin_file_name String; the name of the TOML plugin file; defaults to `$name.toml`.
# @param refresh_heka_service Bool; whether to refresh the Heka daemon when a config file is created or modified.
# @param toml_settings Hash; a hash of INI settings to pass to Puppet's `create_resource` function, which will create `ini_setting` resources for each item in the hash.
#
# === Examples
#
# ::heka::plugin { 'tcpinput4':
#   toml_settings => {
#     'type'        => { setting => 'type', value   => '"TcpInput"', },
#     'address'     => { setting => 'address', value   => '"127.0.0.1:5568"', },
#     'parser_type' => { setting => 'parser_type', value   => '"token"', },
#   }
# }
#
# === Authors
#
# Nicholas Chappell <nchappell@newrelic.com>
#
# === Copyright
#
# Copyright 2015 Nicholas Chappell, unless otherwise noted.

define heka::plugin (
  #Common plugin parameters
  $plugin_dir           = '/etc/heka',
  $plugin_file_name     = "${name}.toml",
  $refresh_heka_service = true,
  $heka_daemon_name     = 'heka',
  $toml_settings        = {}

) {

  include heka::params

  #Do some validation of the parameters:
  validate_string($plugin_dir)
  validate_string($plugin_file_name)
  validate_string($plugin_file_template)
  validate_string($heka_daemon_name)
  validate_hash($toml_settings)

  #Since all of the INI settings will go into the same file, set the file path and name
  #for all ini_setting resources with a resource default. See the following Puppet Labs 
  #documentation for more info:
  # https://docs.puppetlabs.com/puppet/latest/reference/lang_defaults.html
  Ini_setting {
    ensure  => present,
    path    => "${plugin_dir}/${plugin_file_name}", 
    section => $name,  
    notify  => Service[$heka_daemon_name],
  }

  #Create ini_setting resources from the toml_settings hash; each item in the hash will get 
  #made into a separate ini_setting resource; the resource default above makes sure that
  #all of the ini_setting resources are put into the same TOML file:
  create_resources(ini_setting, $toml_settings)

}