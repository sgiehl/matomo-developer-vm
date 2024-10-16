ssl_cert_file     = "#{apache_dir}/ssl/server.crt"
ssl_cert_key_file = "#{apache_dir}/ssl/server.key"
app_dir           = '/var/www/basic_site'

# apache setup

# Needs to be disabled before apache install as it otherwise fails with:
# > STDERR: ERROR: The following modules depend on mpm_prefork and need to be disabled first: php8.2
apache2_module 'php8.2' do
  action :disable
end

apache2_install 'default'

service 'apache2' do
  service_name lazy { apache_platform_service_name }
  supports restart: true, status: true, reload: true
  action [:start, :enable]
end

apache2_module 'proxy'
apache2_module 'proxy_fcgi'

apache2_module 'ssl'
apache2_mod_ssl ''

openssl_x509_certificate 'create-certificate' do
  path ssl_cert_file
  key_file ssl_cert_key_file
  expire 90
  renew_before_expiry 1
  common_name node['matomo']['server_name']
  owner 'root'
  group 'root'
  email 'vm@matomo.org'
  org_unit 'Matomo'
  org 'Matomo.org'
  city 'Everywhere'
  mode '0640'
end

template 'matomo' do
  source 'matomo.conf.erb'
  path "#{apache_dir}/sites-available/matomo.conf"
  variables(
    server_name: node['matomo']['server_name'],
    docroot: node['matomo']['docroot'],
    ssl_cert_file: ssl_cert_file,
    ssl_cert_key_file: ssl_cert_key_file
  )
end

apache2_site '000-default' do
  action :disable
end

apache2_site 'matomo' do
  action :enable
end

#execute 'fix_apache_mod' do
#  command 'sudo echo "LoadModule php_module /usr/lib/apache2/modules/libphp8.2.so" > /etc/apache2/mods-available/php8.2.load'
#end

include_recipe 'ondrej_ppa_ubuntu'

php_install 'php' do
    directives node['php']['directives']
    conf_dir   node['php']['conf_dir']
    packages   node['php']['packages']
  action :install
end

# php-fpm setup
php_fpm_pool 'matomo' do
  user  'vagrant'
  group 'vagrant'

  listen       '127.0.0.1:9000'
  listen_user  'vagrant'
  listen_group 'vagrant'

  fpm_ini_control   node['php']['fpm_ini_control']
  fpm_package       node['php']['fpm_package']
  pool_dir          node['php']['fpm_pooldir']
  service           node['php']['fpm_service']
  default_conf      node['php']['fpm_default_conf']
  fpm_conf_dir      node['php']['fpm_conf_dir']
end

# disable xdebug by default
#execute 'disable_xdebug' do
#  command 'sudo phpdismod xdebug'
#end

php_ini 'fpm' do
  conf_dir node['php']['fpm_conf_dir']
  directives node['php']['directives']
  action :add
end


# mailcatcher requires sqlite3, but the latest version fails to install
packages = %w(ruby ruby-dev libsqlite3-dev build-essential)
packages.each do |pkg|
  package pkg do
    action :install
  end
end

gem_package 'timeout' do
  version '0.4.0'
  package_name 'timeout'
end

gem_package 'net-protocol' do
  version '0.1.2'
  package_name 'net-protocol'
end

gem_package 'net-smtp' do
  version '0.3.0'
  package_name 'net-smtp'
end

gem_package 'net-imap' do
  version '0.2.2'
  package_name 'net-imap'
end

gem_package 'sqlite3' do
  version '1.4.4'
  package_name 'sqlite3'
end

gem_package 'mini_mime' do
  version '1.1.2'
  package_name 'mini_mime'
end

include_recipe "chef-mailcatcher::default"