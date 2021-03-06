require File.dirname(__FILE__) + "/dsl/numerical_string"
require File.dirname(__FILE__) + "/asterisk/agi_server"
require File.dirname(__FILE__) + "/asterisk/ami"
require File.dirname(__FILE__) + "/asterisk/commands"

unless Adhearsion::Events.namespace_registered? :asterisk
  asterisk_namespace = Adhearsion::Events.register_namespace_path :asterisk
  [:before_call, :after_call, :hungup_call, :failed_call].each do |callback_name|
    asterisk_namespace.register_callback_name callback_name
  end
end