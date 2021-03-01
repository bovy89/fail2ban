require 'spec_helper'

describe 'fail2ban::action', type: :define do
  let(:title) { 'myaction' }
  let(:pre_condition) { 'include ::fail2ban' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      describe 'action with all default' do
        let(:params) do
          {
            actionname: 'actionname',
          }
        end
        let(:expected) do
          "# This file is managed by Puppet. DO NOT EDIT.
#
[INCLUDES]


[Definition]


[Init]
"
        end

        it { is_expected.to contain_file("#{params[:actionname]}.local").with_content(expected) }
      end

      describe 'action with all parameters' do
        let(:params) do
          {
            actionname: 'actionname',
            actionstart: ['actionstart'],
            actionstop: ['actionstop'],
            actioncheck: ['actioncheck'],
            actionban: ['first_ban_action', 'second_ban_action', 'complex[ban]'],
            actionunban: ['actionunban'],
            actioninitvars: ['a = 1', 'b = 2', 'not c'],
            actionbefore: 'actionbefore',
            actionafter: 'actionafter',
          }
        end
        let(:expected) do
          "# This file is managed by Puppet. DO NOT EDIT.
#
[INCLUDES]

before = actionbefore
after = actionafter

[Definition]

actionstart = actionstart
actionstop = actionstop
actioncheck = actioncheck
actionban = first_ban_action
\tsecond_ban_action
\tcomplex[ban]
actionunban = actionunban

[Init]
a = 1
b = 2
not c
"
        end

        it { is_expected.to contain_file("#{params[:actionname]}.local").with_content(expected) }
      end
    end
  end
end
