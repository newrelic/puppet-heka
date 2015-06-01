#Changelog
- - -

###version 0.1.1 (unreleased)

* Added package versioning support

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