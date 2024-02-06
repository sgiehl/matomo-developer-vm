
include_recipe "chrome"

npm_package 'screenshot-testing' do
    path '/srv/matomo/tests/lib/screenshot-testing'
    json true
    user 'vagrant'
end

# imagemagick setup
include_recipe 'imagemagick::default'

# ensure the same fonts are used as in githu action
execute 'copy_fonts' do
  command <<-CMD
    [ -d /home/vagrant/.fonts ] || mkdir /home/vagrant/.fonts;
    [ -d /home/vagrant/action/artifacts/fonts ] || git clone -b main --single-branch --depth 1 https://github.com/matomo-org/github-action-tests.git /home/vagrant/action
    [ ! -d /home/vagrant/action/artifacts/fonts ] || cp -f /home/vagrant/action/artifacts/fonts/* /home/vagrant/.fonts
    CMD
  user  'vagrant'
  group 'vagrant'
end