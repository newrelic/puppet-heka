#Changelog
- - -

###version 0.2.0 (unreleased)

* [Issue #2](https://github.com/newrelic/puppet-heka/issues/2) and [PR #9](https://github.com/newrelic/puppet-heka/pull/9): Don't allow `type` parameters on custom plugins 
* [Issue #3](https://github.com/newrelic/puppet-heka/issues/3) and [PR #6](https://github.com/newrelic/puppet-heka/pull/6): Added package versioning support
* [Issue #5](https://github.com/newrelic/puppet-heka/issues/5) and [PR #8](https://github.com/newrelic/puppet-heka/pull/8): Make management of the Heka service optional.
* [Issue #13](https://github.com/newrelic/puppet-heka/issues/13) and [PR #14](https://github.com/newrelic/puppet-heka/pull/14): Added the ability to purge unmanaged TOML config files

###version 0.1 (March 13th, 2015)

* Added Heka installation via packages, init script/systemd unit file templating and service management
* Added management of `/etc/heka.toml`
* Added support for setting custom global config options
* Added defined types for:
	* `StatAccumInput`
	* `StatsdInput`
	* `TcpInput`
	* `UdpInput`
	* `CarbonOutput`
* Added a custom plugin defined type