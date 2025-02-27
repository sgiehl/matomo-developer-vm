package 'mysql-server' do
  action :install
end

execute 'create_mysqlcnf' do
  command <<-MYCNF
    echo '
[mysql]
local-infile

[mysqld]
local-infile
secure_file_priv = ""
    ' > /etc/mysql/conf.d/mysql.cnf
  MYCNF
end

execute 'matomo_database' do
  command <<-DBSQL
  mysql -uroot -e '
      CREATE DATABASE IF NOT EXISTS \`#{node['matomo']['mysql_database']}\`
  '
  DBSQL
end

execute 'matomo_database_settings' do
  command <<-DBSQL
  mysql -uroot -e '
      SET @@GLOBAL.innodb_flush_log_at_trx_commit = 2;
      SET @@GLOBAL.max_allowed_packet = 67108864;
  '
  DBSQL
end

execute 'matomo_database_user' do
  command <<-USERSQL
  mysql -uroot -e '
      CREATE USER IF NOT EXISTS "#{node['matomo']['mysql_username']}"@"localhost"
      IDENTIFIED BY "#{node['matomo']['mysql_password']}";
      GRANT ALL ON *.*
      TO "#{node['matomo']['mysql_username']}"@"localhost";
  '
  USERSQL
end

unless node['matomo']['vm_type'] == 'minimal'
  execute 'matomo_tests_database' do
    command <<-DBSQL
    mysql -uroot -e '
        CREATE DATABASE IF NOT EXISTS \`matomo_tests\`
    '
    DBSQL
  end
end

# mysql setup
# HACK: ensure mysql is started after installation
execute 'mysql_start' do # ~FC004
  command '/etc/init.d/mysql restart || true'
end

execute 'create_mycnf' do
  command <<-MYCNF
    echo '
[client]
user=#{node['matomo']['mysql_username']}
password=#{node['matomo']['mysql_password']}
    ' > /home/vagrant/.my.cnf
  MYCNF
end