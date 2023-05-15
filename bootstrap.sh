#!/bin/sh

CHEFDK_PKG='chef-workstation_22.10.1013-1_amd64.deb'
CHEFDK_SHA256='b07dad6e2323e673b6e8ab8894307b9e313cf7f34016a75d4f62434e6128f7d8'

command -v berks >/dev/null 2>&1 || {
  echo 'Updating APT repositories...'
  apt-get update -qq

  cd /tmp

  [ ! -f "${CHEFDK_PKG}" ] && {
    echo 'Downloading Chef Workstation...'

    wget --quiet "https://packages.chef.io/files/stable/chef-workstation/22.10.1013/ubuntu/18.04/${CHEFDK_PKG}"

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
