require "logplexer/version"
require "honeybadger"
require 'logplexer/railtie' if defined?(Rails)

module Logplexer

  extend self

  # Dyamically create all the class log methods for Rails logger
  %W(debug info warn error fatal).each do |log_type|
    class_eval  <<-RUBY
      def #{log_type}(exception, opts = {})
        log( exception, "#{log_type}", opts )
      end
    RUBY
  end

  def log( exception, log_type, opts = {})
    # We wrap the Honeybadger notify call so that in development,
    # we actually see the errors. Then we can unwrap the REST errors
    # if need be
    return if exception.nil?

    logfile = opts.delete( :logfile )
    logger = Logger.new( logfile || STDOUT )

    # Override the verbosity if LOG_VERBOSE is unset
    verbose = ENV["LOG_VERBOSE"] == "true" ? true : opts.delete( :verbose )

    if ENV['LOG_TO_HB'] == "true"
      #TODO: Maybe extend this to include other kinds of notifiers.
      if exception.is_a? String
        exception = { error_class: "Exception",
                      error_message: exception }
      end
      Honeybadger.notify( exception, opts )
    else
      # Make sure that the exception is an actual exception and
      # not just a hash since Honeybadger accepts both
      if exception.is_a? Exception
        logger.send( log_type, exception.message )
        if verbose
          exception.backtrace.each do |entry|
            logger.send( log_type, "> #{entry}" ) 
          end
        end

      elsif exception.is_a? String
        # Log just the string if thats what the user wants
        logger.send( log_type, exception )

      else
        # Default kind of log for an object or whatevs
        logger.send( log_type, exception.inspect )
      end
    end
  end
end
