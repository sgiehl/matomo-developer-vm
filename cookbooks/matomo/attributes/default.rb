default['matomo']['vm_type'] = 'minimal'

default['matomo']['docroot']        = '/srv/matomo'
default['matomo']['mysql_database'] = 'matomo'
default['matomo']['mysql_password'] = 'matomo'
default['matomo']['mysql_username'] = 'matomo'
default['matomo']['server_name']    = 'dev.matomo.io'

default['mailcatcher']['version'] = '0.8.2'

default['redisio']['bin_path']        = '/usr/bin'
default['redisio']['package_install'] = true
default['redisio']['version']         = nil

default['nodejs']['install_method'] = 'binary'
default['nodejs']['version'] = '16.18.1'
default['nodejs']['binary']['checksum'] = '8949919fc52543efae3bfd057261927c616978614926682ad642915f98fe1981'

default['php']['fpm_ini_control'] = true
default['php']['directives'] = {
                                 :'memory_limit' => '1024m',
                                 :'max_execution_time' => 90,
                                 :'xdebug.max_nesting_level' => 200,
                                 :'xdebug.remote_enable' => 1,
                                 :'xdebug.remote_host' => '192.168.99.1',
                                 :'xdebug.output_dir' => '/srv/matomo',
                                 :'profiler_output_name' => 'cachegrind.out.%p'
                               }
