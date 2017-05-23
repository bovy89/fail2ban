require 'spec_helper'


describe 'fail2ban', :type => :class do
  context "on a CentoOS 7 OS" do
    let(:facts) do
      {
        :osfamily                  => 'RedHat',
        :operatingsystemmajrelease => '7',
        :operatingsystemrelease    => '7.0.1406',
        :operatingsystem           => 'CentOS',
      }
    end

    context 'with default values for all parameters' do
      let(:expected) do
"# This file is managed by Puppet. DO NOT EDIT.
#
[Definition]

"
      end
      it { should create_class('fail2ban') }
      it { should compile }
      it { should contain_package('fail2ban').with(
        :ensure  => 'present',
        :require => nil,
      )}

      it { should contain_service('fail2ban').with(
        :enable => true,
        :ensure => 'running',
        :name   => 'fail2ban',
      )}

      it { should contain_file('/etc/fail2ban/fail2ban.local').with_content(expected) }
      it { should_not contain_file('/etc/fail2ban') }
      it { should_not contain_file('/etc/fail2ban/jail.local') }
      
    end

    context 'with default values and config_file customizations' do
      let(:params) do
        {
          :log_level  => 'DEBUG',
          :log_target => '/var/log/fail2ban.log',
        }
      end
      let(:expected) do
"# This file is managed by Puppet. DO NOT EDIT.
#
[Definition]

loglevel = DEBUG
logtarget = /var/log/fail2ban.log
"
      end
      it { should contain_file('/etc/fail2ban/fail2ban.local').with_content(expected) }
    end

    context 'with use_epel => true' do
      let(:params) { { :use_epel => true } }
      it { should contain_package('fail2ban').with(
        :ensure  => 'present',
        :require => 'Class[Epel]',
      )}
    end

    context 'with service_ensure => stopped' do
      let(:params) { { :service_ensure => 'stopped' } }
      it { should contain_service('fail2ban').with(
        :enable => true,
        :ensure => params[:service_ensure],
        :name   => 'fail2ban',
      )}
    end

    context 'with disableboot => true' do
      let(:params) { { :disableboot => true } }
      it { should contain_service('fail2ban').with(
        :enable => false,
        :ensure => 'running',
        :name   => 'fail2ban',
      )}
    end

    context 'with fail2ban_ensure => absent' do
      let(:params) { { :fail2ban_ensure => 'absent' } }
      it { should contain_package('fail2ban').with(
        :ensure => params[:fail2ban_ensure],
      )}
    end

    context 'with source_dir => puppet:///modules/mymodule/fail2ban_src' do
      let(:params) { { :source_dir => 'puppet:///modules/mymodule/fail2ban_src' } }
      it { should contain_file('/etc/fail2ban').with(
        'source'  => params[:source_dir],
      )}
    end

    context 'with jails_config => file' do
      let(:params) { { :jails_config => 'file' } }
      it { should compile.and_raise_error(/jails_config => file without content and with fail2ban_ensure => present/) }
    end

    context 'with jails_config => file and jails_content' do
      let(:params) do
        {
          :jails_config  => 'file',
          :jails_content => 'mycontent',
        }
      end
      it { should contain_file('/etc/fail2ban/jail.local').with(
        'content' => params[:jails_content],
      )}
    end

    context 'with jails_config => file and fail2ban_ensure => absent' do
      let(:params) do
        {
          :jails_config    => 'file',
          :fail2ban_ensure => 'absent',
        }
      end
      it { should contain_file('/etc/fail2ban/jail.local').with(
        :ensure => 'absent',
      )}
    end
  end
end
