# == Class: heka::service
#
# This class manages the Heka daemon as a regular service. It uses the Upstart or systemd
# init/unit files that are managed by the heka::config class.
#
# === Parameters
#
# @param service_ensure String; the state the Heka daemon should be set to; defaults to `running`
# @param service_enable Bool; whether the Heka daemon should be enabled to start on system boot; defaults to `true`
# @param heka_daemon_name String; the name of the Heka daemon; defaults to `heka` for both Red Hat/CentOS and Debian/Ubuntu
#
# === Authors
#
# Nicholas Chappell <nchappell@newrelic.com>
#
# === Copyright
#
# Copyright 2015 Nicholas Chappell, unless otherwise noted.
class heka::service (
  $service_ensure   = $heka::params::service_ensure,
  $service_enable   = $heka::params::service_enable,
  $heka_daemon_name = $heka::params::heka_daemon_name
) inherits heka::params {

  service { $heka_daemon_name:
    ensure   => $service_ensure,
    provider => $service_provider,
    enable => $service_enable
  }

}