require 'gserver'
module Adhearsion
  module VoIP
    module Asterisk
      module AGI
        class Server
          Thread.current.abort_on_exception=true
          
          class RubyServer < GServer
        
            def serve(io)
              begin
            	  @call = Adhearsion.receive_call_from io
            	  puts "Handling call with variables #{@call.variables.inspect}" # Should be sent to a logger
            	  Adhearsion::DialPlan::Manager.new.handle(@call)
          	  rescue Adhearsion::UselessCallException
          	    puts "Ignoring meta-AGI request"
          	    @call.hangup!
          	  rescue => e
          	    #TODO: This is temporary
          	    logger = Logger.new(STDOUT)
          	    logger.error e.inspect
          	    logger.error e.backtrace.join("\n")
        	    end
          	  # TBD: (may have more hooks than what Jay has defined in hooks.rb) Adhearsion::Hooks::BeforeHelpersLoad.trigger_hooks!
          	  #     Rich says how about regisering hooks into  Call's lifecycle?  Excellent idea.  We could manage state transitions as a first-class
          	  #     thing for calls.
          	  # SKIP: (This feature will come later) SOME PBX.call thing which I don't think actually works in adhearsion 0.7.x
          	  # execute_after_hooks              
            end
          end
         
          DEFAULT_OPTIONS = { :server_class => RubyServer, :port => 4573, :host => "0.0.0.0" } unless defined? DEFAULT_OPTIONS
          attr_reader :host, :port, :server_class, :server

          def initialize(options = {})
            options                     = DEFAULT_OPTIONS.merge options
            @host, @port, @server_class = options.values_at(:host, :port, :server_class)
            @server                     = server_class.new(port, host)
          end

          def start
            server.start
          end

          def shutdown
            server.stop
          end
          
          def join
            server.join
          end
          
        end
      end
    end
  end
end