require 'spec_helper'

describe 'ceilometer::logging' do

  let :log_params do
    {
      :logging_context_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s',
      :logging_default_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s',
      :logging_debug_format_suffix => '%(funcName)s %(pathname)s:%(lineno)d',
      :logging_exception_prefix => '%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s',
      :log_config_append => '/etc/ceilometer/logging.conf',
      :publish_errors => true,
      :default_log_levels => 'amqp=WARN,amqplib=WARN,boto=WARN,qpid=WARN,sqlalchemy=WARN,suds=INFO,iso8601=WARN,requests.packages.urllib3.connectionpool=WARN',
     :fatal_deprecations => true,
     :instance_format => '[instance: %(uuid)s] ',
     :instance_uuid_format => '[instance: %(uuid)s] ',
     :log_date_format => '%Y-%m-%d %H:%M:%S',
    }
  end

  shared_examples_for 'ceilometer::logging' do

    context 'with extended logging options' do
      before { params.merge!( log_params ) }
      it_configures 'logging params set'
    end

    context 'without extended logging options' do
      it_configures 'logging params unset'
    end

  end

  shared_examples_for 'logging params set' do
      params.keys { |key|
        it { should contain_ceilometer_config("DEFAULT/#{key}").with_value( params[key] ) }
        }
  end

  shared_examples_for 'logging params unset' do
      params.keys { |key|
        it { should contain_ceilometer_config("DEFAULT/#{key}").with_ensure('absent') }
        }
  end
end
