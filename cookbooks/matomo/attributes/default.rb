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

default['php']['directives'] = {
                                 'memory_limit': '1024m',
                                 'max_execution_time': 90,
                                 'xdebug.max_nesting_level': 200,
                                 'xdebug.remote_enable': 1,
                                 'xdebug.remote_host': '192.168.99.1',
                                 'xdebug.output_dir': '/srv/matomo',
                                 'profiler_output_name': 'cachegrind.out.%p',
                               }
default['php']['conf_dir']         = '/etc/php/8.2/cli'
default['php']['packages']         = %w(php8.2 php8.2-curl php8.2-dom php8.2-mbstring php8.2-gd php8.2-mysql php8.2-bz2 php8.2-zip php8.2-xdebug php8.2-redis php8.2-soap)
default['php']['fpm_ini_control'] = true
default['php']['fpm_package']      = 'php8.2-fpm'
default['php']['fpm_pooldir']      = '/etc/php/8.2/fpm/pool.d'
default['php']['fpm_service']      = 'php8.2-fpm'
default['php']['fpm_socket']       = '/var/run/php/php8.2-fpm.sock'
default['php']['fpm_default_conf'] = '/etc/php/8.2/fpm/pool.d/www.conf'
default['php']['fpm_conf_dir']     = '/etc/php/8.2/fpm'
default['php']['enable_mod']       = '/usr/sbin/phpenmod'
default['php']['disable_mod']      = '/usr/sbin/phpdismod'
default['php']['ext_conf_dir']     = '/etc/php/8.2/mods-available'
