#!/bin/bash

set -e
set -x

dnf -q install -y rpm-build 'dnf-command(builddep)'
dnf -q builddep -y mod_authnz_pam.spec
rpm -q --qf '%{name}-%{version}\n' --specfile mod_authnz_pam.spec | head -1 > name_version
mkdir $( cat name_version )
cp -rp * $( cat name_version )
mkdir -p ~/rpmbuild/SOURCES
tar cvzf ~/rpmbuild/SOURCES/$( cat name_version ).tar.gz $( cat name_version )
rpmbuild -bb --define "dist $( rpm --eval '%{dist}' ).localbuild" mod_authnz_pam.spec
dnf -q install -y ~/rpmbuild/RPMS/*/$( cat name_version )-*.localbuild.*.rpm
