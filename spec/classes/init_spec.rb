require 'spec_helper'


describe 'fail2ban', :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe 'with default values for all parameters' do
        let(:expected) do
"# This file is managed by Puppet. DO NOT EDIT.
#
[Definition]

"
        end
        it { is_expected.to create_class('fail2ban') }
        it { is_expected.to compile }
        it { is_expected.to contain_package('fail2ban').with(
          :ensure  => 'present',
          :require => nil,
        )}

        it { is_expected.to contain_service('fail2ban').with(
          :enable => true,
          :ensure => 'running',
          :name   => 'fail2ban',
        )}

        it { is_expected.to contain_file('/etc/fail2ban/fail2ban.local').with_content(expected) }
        it { is_expected.not_to contain_file('/etc/fail2ban') }
        it { is_expected.not_to contain_file('/etc/fail2ban/jail.local') }
      end

      describe 'with default values and config_file customizations' do
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
        it { is_expected.to contain_file('/etc/fail2ban/fail2ban.local').with_content(expected) }
      end

      describe 'with use_epel => true' do
        let(:params) { { :use_epel => true } }
        it { is_expected.to contain_package('fail2ban').with(
          :ensure  => 'present',
          :require => 'Class[Epel]',
        )}
      end

      describe 'with service_ensure => stopped' do
        let(:params) { { :service_ensure => 'stopped' } }
        it { is_expected.to contain_service('fail2ban').with(
          :enable => true,
          :ensure => params[:service_ensure],
          :name   => 'fail2ban',
        )}
      end

      describe 'with disableboot => true' do
        let(:params) { { :disableboot => true } }
        it { is_expected.to contain_service('fail2ban').with(
          :enable => false,
          :ensure => 'running',
          :name   => 'fail2ban',
        )}
      end

      describe 'with fail2ban_ensure => absent' do
        let(:params) { { :fail2ban_ensure => 'absent' } }
        it { is_expected.to contain_package('fail2ban').with(
          :ensure => params[:fail2ban_ensure],
        )}
      end

      describe 'with source_dir => puppet:///modules/mymodule/fail2ban_src' do
        let(:params) { { :source_dir => 'puppet:///modules/mymodule/fail2ban_src' } }
        it { is_expected.to contain_file('/etc/fail2ban').with(
          'source'  => params[:source_dir],
        )}
      end

      describe 'with jails_config => file' do
        let(:params) { { :jails_config => 'file' } }
        it { is_expected.to compile.and_raise_error(/jails_config => file without content and with fail2ban_ensure => present/) }
      end

      describe 'with jails_config => file and jails_content' do
        let(:params) do
          {
            :jails_config  => 'file',
            :jails_content => 'mycontent',
          }
        end
        it { is_expected.to contain_file('/etc/fail2ban/jail.local').with(
          'content' => params[:jails_content],
        )}
      end

      describe 'with jails_config => file and fail2ban_ensure => absent' do
        let(:params) do
          {
            :jails_config    => 'file',
            :fail2ban_ensure => 'absent',
          }
        end
        it { is_expected.to contain_file('/etc/fail2ban/jail.local').with(
          :ensure => 'absent',
        )}
      end
    end
  end
end
