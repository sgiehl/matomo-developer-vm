# Matomo Developer VM

## Requirements

This virtual machine is using Vagrant and Virtual Box.

In addition the following vagrant plugins are required:
* vagrant-devcommands
* vagrant-hostmanager (optionally)
* vagrant-winnfsd (only on Windows)

Those vagrant plugins can be installed with e.g. `./vagrant plugin install vagrant-devommands`

## Configuration

Default configuration is stored in `config.yml`. This configuration file can be overwritten by creating a `config.local.yml`

### Available options:

#### IP of virutal box

```
vm_ip: 192.168.99.100
```

#### Name of virtual box
```
vm_name: matomo
```

#### Type of virutal box
``` 
vm_type: full
```

This can be set to either `minimal` or `full`.

Choose `minimal` for a default set up that includes everything for basic development of Matomo. This includes installing:

* MySQL server
* PHP 7.2 including extensions (curl mbstring gd mysql bz2 zip xdebug redis soap)
* Apache configured to use php-fpm
* Python3 (for log importer)
* Composer

Chosse `full` for full set up, which includes some additional tools and actions to run UI tests or javascript tests on command line. This additionally includes:

* Redis server
* Chrome, ImageMagick (for UI tests)
* Perl package `MaxMind::DB::Writer::Serializer` (required to build the GeoIP databases used for testing)
* woff2 (for building font files)

#### Hostname for matomo instance
```
server_name: dev.matomo.io
```

#### Directory of Matomo repo
```
source: ../matomo
```

Configure this so it points to the directory where your Matomo checkout is located. The folder will be automatically mounted into the VM.

#### Directory of Device Detector repo
```
source_device_detector: ../device-detector
```

Configure this so it points to the directory where your Device Detector checkout is located. The folder will be automatically mounted into the VM.

Can be left empty if device detector development won't be needed.

#### MySQL configuration
```
mysql_database: matomo
mysql_password: matomo
mysql_username: matomo
```

This configuration options will be used to set up the database and a user.

#### Matomo plugin
```
plugin_glob: ../{matomo-plugin,plugin}-[a-zA-Z]*/
plugin_pattern: plugin-([a-zA-Z]*)$
```

This options can be used if you have additional Matomo plugin checkouts that should be mounted into the VM. The `plugin_glob` will be used to search for plugin directory. The resulting match of `plugin_pattern` will be used as plugin name. If there is for example a directory `../plugin-MyCustomPlugin` it will be mounted in the VM as `/srv/matomo/plugins/MyCustomPlugin` and thus should be available as plugin within Matomo.

## Commands

Using the vagrant-devcommands plugin the VM has various helpful commands. Those commands can be executed outside of the vm, within the vm repo folder using `vagrant run %command%` and will be directly executed in the vm.

#### Run Console Command

```bash
vagrant run console --command="development:enable"
```

The command option can be left empty in order to see to available commands. 

#### En-/Disable Xdebug
```bash
vagrant run xdebug-enable
vagrant run xdebug-disable
```

Those commands can be used to en- or disable xdebug for PHP. As xdebug can slow down the application and tests xdebug is disabled by default.

#### Export / Import MySQL database
```bash
vagrant run dump-export
vagrant run dump-export
```

As the database is stored within the VM it is destroyed together with the VM. If you need to recreate the VM and want to reuse the database those commands can be used to simply export and import the database. The database export will be stored in the directory `sqldumps/matomo.sql` in the VM repo (outside of the VM)

#### Open MySQL console
```bash
vagrant run mysql 
```

Opens a mysql console to the server


#### Device Detector commands

If device detector is configured there are additionally this commands available

##### Run Device Detector Tests
```bash
vagrant run dd-tests 
```

##### Parse A User-Agent
```bash
vagrant run dd-parse --agent="%useragent%" 
```

##### Update the Device Detector README
```bash
vagrant run dd-readme 
```

## License

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
