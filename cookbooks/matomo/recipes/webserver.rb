packages = %w(php7.2 php7.2-curl php7.2-mbstring php7.2-gd php7.2-mysql php7.2-bz2 php7.2-zip php7.2-xdebug php7.2-redis php7.2-soap php7.2-dom)

packages.each do |pkg|
  package pkg do
    action :install
  end
end

# disable xdebug by default
execute 'disable_xdebug' do
  command 'sudo phpdismod xdebug'
end

ssl_cert_file     = "#{apache_dir}/ssl/server.crt"
ssl_cert_key_file = "#{apache_dir}/ssl/server.key"
app_dir           = '/var/www/basic_site'

# apache setup

# Needs to be disabled before apache install as it otherwise fails with:
# > STDERR: ERROR: The following modules depend on mpm_prefork and need to be disabled first: php7.2
apache2_module 'php7.2' do
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

# php-fpm setup
php_fpm_pool 'matomo' do
  user  'vagrant'
  group 'vagrant'

  listen       '127.0.0.1:9000'
  listen_user  'vagrant'
  listen_group 'vagrant'
end

# mailcatcher requires sqlite3, but the latest version fails to install
packages = %w(ruby ruby-dev libsqlite3-dev build-essential)
packages.each do |pkg|
  package pkg do
    action :install
  end
end

gem_package 'sqlite3' do
  version '1.4.4'
  package_name 'sqlite3'
end

include_recipe "chef-mailcatcher::default"