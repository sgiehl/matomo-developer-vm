default['matomo']['vm_type'] = 'minimal'

default['matomo']['docroot']        = '/srv/matomo'
default['matomo']['mysql_database'] = 'matomo'
default['matomo']['mysql_password'] = 'matomo'
default['matomo']['mysql_username'] = 'matomo'
default['matomo']['server_name']    = 'dev.matomo.io'

default['redisio']['bin_path']        = '/usr/bin'
default['redisio']['package_install'] = true
default['redisio']['version']         = nil

default['nodejs']['version'] = '14.17.5'
default['nodejs']['binary']['checksum'] = 'dc04c7e60235ff73536ba0d9e50638090f60cacabfd83184082dce3b330afc6e'

default['php']['fpm_ini_control'] = true
default['php']['directives'] = { :'xdebug.max_nesting_level' => 200, :'memory_limit' => '512m', :'max_execution_time' => 90 }
