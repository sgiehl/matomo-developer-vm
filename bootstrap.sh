#!/bin/sh

CHEFDK_PKG='chef-workstation_24.8.1068-1_amd64.deb'
CHEFDK_SHA256='e6354faa352c120216efb554abdc086e475da6584e8e3f3e7152bd6343763786'

command -v berks >/dev/null 2>&1 || {
  echo 'Updating APT repositories...'
  apt-get update -qq

  cd /tmp

  [ ! -f "${CHEFDK_PKG}" ] && {
    echo 'Downloading Chef Workstation...'

    wget --quiet "https://packages.chef.io/files/stable/chef-workstation/24.8.1068/ubuntu/20.04/${CHEFDK_PKG}"

    dl_sha256="$(sha256sum /tmp/${CHEFDK_PKG} | awk '{ print $1 }')"

    if [ "${CHEFDK_SHA256}" != "${dl_sha256}" ]; then
      echo 'Chef Workstation download checksum mismatch!'
      echo "Expected: ${CHEFDK_SHA256}"
      echo "Received: ${dl_sha256}"

      exit 1
    fi
  }

  dpkg -i "${CHEFDK_PKG}"
  rm -f "${CHEFDK_PKG}"
}

echo 'Updating Chef dependencies...'

cd /vagrant && berks vendor
