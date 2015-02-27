require 'spec_helper'

enable_service = %w(acpid auditd crond ip6tables iptables kdump 
                    mdmonitor netfs network nfslock ntpd ntpdate 
                    rpcbind rpcgssd rsyslog sshd sysstat udev-post 
                    vboxadd vboxadd-service vboxadd-x11)

unable_service = %w(htcacheclean netconsole nfs postfix rdisc 
                    restorecond rpcsvcgssd saslauthd svnserve)

enable_service.each do |service|
  describe service("#{service}") do
    it { should be_enabled.with_level(3) }
  end
end

unable_service.each do |service|
  describe service("#{service}") do
    it { should_not be_enabled.with_level(3) }
  end
end

command("rpm -qai |grep Name |grep Relocations |awk '{print $3}'").stdout.each_line do |pkg|
  describe package("#{pkg.chomp}") do
    it { should be_installed }
  end
end

describe command('ls -al /') do
  its(:stdout) { should match /bin/ }
end

describe file('/etc/passwd') do
  it { should be_file }
end

describe file('/var/log/httpd') do
  it { should be_directory }
end

describe file('/etc/httpd/conf/httpd.conf') do
  its(:content) { should match /^#ServerName www\.example\.com\:80$/ }
end

describe file('/') do
  it { should be_mounted }
end

command("awk -F\":\" '{ print $1}' /etc/passwd").stdout.each_line do |user|
  describe user("#{user.chomp}") do
    it { should exist }
  end
end

command("awk -F\":\" '{ print $1}' /etc/group").stdout.each_line do |group|
  describe group("#{group.chomp}") do
    it { should exist }
  end
end

describe interface('eth0') do
  it { should exist }
end


