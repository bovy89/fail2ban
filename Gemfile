source ENV['GEM_SOURCE'] || "https://rubygems.org"

puppetversion = ENV.key?('PUPPET_GEM_VERSION') ? "= #{ENV['PUPPET_GEM_VERSION']}" : ['>= 3.3']
gem 'puppet', puppetversion
gem 'facter', '>= 1.7.0'

group :development, :unit_tests do
  gem 'rake',                                                      '< 11.0.0'
  gem 'rspec-puppet',                                              :require => false
  gem 'parallel_tests', "~> 2.9.0",                                :require => false
  gem 'rspec-puppet-facts',                                        :require => false
  gem 'puppetlabs_spec_helper',                                    :require => false
  gem 'puppet-lint', "1.0.1",                                      :require => false
  gem 'json', "~> 1.8.3",                                          :require => false
  gem 'json_pure', "~> 1.8.3",                                     :require => false
  gem 'puppet-syntax',                                             :require => false
  gem 'metadata-json-lint',                                        :require => false
  gem 'puppet-blacksmith',                                         :require => false
  gem 'rest-client', "1.6.8",                                      :require => false
  gem 'puppet-lint-absolute_classname-check',                      :require => false
  gem 'puppet-lint-appends-check',                                 :require => false
  gem 'puppet-lint-empty_string-check',                            :require => false
  gem 'puppet-lint-file_ensure-check',                             :require => false
  gem 'puppet-lint-leading_zero-check',                            :require => false
  gem 'puppet-lint-spaceship_operator_without_tag-check',          :require => false
  gem 'puppet-lint-trailing_comma-check',                          :require => false
  gem 'puppet-lint-undef_in_function-check',                       :require => false
  gem 'puppet-lint-unquoted_string-check',                         :require => false
  gem 'puppet-lint-version_comparison-check',                      :require => false
  gem 'puppet-lint-variable_contains_upcase',                      :require => false
  gem 'puppet-lint-alias-check',                                   :require => false
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check', :require => false
  gem 'puppet-lint-file_source_rights-check',                      :require => false

end

group :system_tests do
  gem 'beaker-rspec',    :require => false
  gem 'serverspec',      :require => false
  gem 'vagrant-wrapper', :require => false
end

group :development do
  gem 'simplecov',          :require => false
  gem 'guard-rake',         :require => false
  gem 'listen', '~> 3.0.0', :require => false
end

