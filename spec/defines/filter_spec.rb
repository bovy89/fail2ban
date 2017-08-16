require 'spec_helper'


describe 'fail2ban::filter', :type => :define do
  let(:title) { 'myfilter' }
  let(:pre_condition) { 'include ::fail2ban' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe 'filter with all default' do
        let(:params) do
          {
            :filtername => 'filtername',
          }
        end
        let(:expected) do
"# This file is managed by Puppet. DO NOT EDIT.
#
[INCLUDES]


[Definition]

failregex = 
ignoreregex = 


"
        end
        it { is_expected.to contain_file("#{params[:filtername]}.local").with_content(expected) }
      end

      describe 'filter with all parameters' do
        let(:params) do
         {
           :filtername           => 'filtername',
           :filterfailregex      => ['first_fail_regex','second_fail_regex','complex[filter]'],
           :filterignoreregex    => ['now_ignore'],
           :filterdefinitionvars => ['a = 1','b = 2', 'not c'],
           :filterbefore         => 'add_before',
           :filterafter          => 'add_after',
         }
        end
        let(:expected) do
"# This file is managed by Puppet. DO NOT EDIT.
#
[INCLUDES]

before = add_before
after = add_after

[Definition]

failregex = first_fail_regex
\tsecond_fail_regex
\tcomplex[filter]
ignoreregex = now_ignore

a = 1
b = 2
not c

"
        end
        it { is_expected.to contain_file("#{params[:filtername]}.local").with_content(expected) }
      end
    end
  end
end
