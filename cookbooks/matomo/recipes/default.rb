# package setup
include_recipe 'apt'
include_recipe 'matomo::database'
include_recipe 'matomo::webserver'

unless node['matomo']['vm_type'] == 'minimal'
  include_recipe 'redisio'
  include_recipe 'redisio::enable'

  ## stuff required to run UI tests locally
  include_recipe 'matomo::uitests'

  ## stuff required to build GeoIP2 databases
  include_recipe 'matomo::geoip'
end


packages = %w(git unzip curl python3)

unless node['matomo']['vm_type'] == 'minimal'
  # note: libxss1 is required for chrome to run correctly as node module
  packages += %w(git-lfs openjdk-8-jre woff2 libxss1)

  packagecloud_repo 'github/git-lfs' do
    type 'deb'
  end
end

packages.each do |pkg|
  package pkg do
    action :install
  end
end

# link python executable
execute 'python_link' do
  command '[ -L /usr/bin/python ] || ln -s /usr/bin/python3 /usr/bin/python'
end

# composer setup
include_recipe 'composer::self_update'

execute 'console_autocomplete' do
  command <<-CMD
    composer global require bamarni/symfony-console-autocomplete
    echo 'PATH="$PATH:/home/vagrant/.config/composer/vendor/bin" \
          eval "$(symfony-autocomplete)"' > /home/vagrant/.bash_profile
  CMD
end

composer_project node['matomo']['docroot'] do
  dev    true
  quiet  true
  action :install
end

# run npm install
include_recipe "nodejs"

npm_package 'screenshot-testing' do
    path '/srv/matomo/'
    json true
    user 'vagrant'
end