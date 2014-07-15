Name: hydra-worker-round-robin
Version: 1
Release: 0
Summary: hydra-worker-round-robin
Source0: hydra-worker-round-robin-1.0.tar.gz
License: MIT
Group: custom
URL: https://github.com/innotech/hydra-worker-round-robin
BuildArch: x86_64
BuildRoot: %{_tmppath}/%{name}-buildroot
Requires: libzmq3
%description
Sort instances by round-robin algorithmm.
%prep
%setup -q
%build
%install
install -m 0755 -d $RPM_BUILD_ROOT/usr/local/hydra
install -m 0755 hydra-worker-round-robin $RPM_BUILD_ROOT/usr/local/hydra/hydra-worker-round-robin

install -m 0755 -d $RPM_BUILD_ROOT/etc/init.d
install -m 0755 hydra-worker-round-robin-init.d.sh $RPM_BUILD_ROOT/etc/init.d/hydra-worker-round-robin

install -m 0755 -d $RPM_BUILD_ROOT/etc/hydra
install -m 0644 hydra.conf $RPM_BUILD_ROOT/etc/hydra/hydra-worker-round-robin.conf
%clean
rm -rf $RPM_BUILD_ROOT
%post
echo   You should edit config file /etc/hydra/hydra-worker-round-robin.conf
echo   When finished, you may want to run \"update-rc.d hydra-worker-round-robin defaults\"
%files
/usr/local/hydra/hydra-worker-round-robin
/etc/init.d/hydra-worker-round-robin
