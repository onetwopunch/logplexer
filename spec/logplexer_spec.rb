require 'spec_helper'

describe Logplexer do
  it 'has a version number' do
    expect(Logplexer::VERSION).not_to be nil
  end

  it 'should respond to all methods created through meta' do
    expect(Logplexer.respond_to? :debug).to eq( true )
    expect(Logplexer.respond_to? :info).to eq( true )
    expect(Logplexer.respond_to? :warn).to eq( true )
    expect(Logplexer.respond_to? :error).to eq( true )
    expect(Logplexer.respond_to? :fatal).to eq( true )
  end

  it 'should log to STDOUT' do
    Logger.any_instance.should_receive(:error).with("WAT")
    Logplexer.error("WAT")
  end

  it 'should handle hashes as exceptions' do
    h = {a: "hello", b: "world"}
    Logger.any_instance.should_receive(:info).with(h.inspect)
    Logplexer.info(h)
  end

  it 'should handle backtrace on verbose' do
    ex = Exception.new("Much error, many wrongs")
    allow(ex).to receive(:backtrace).and_return(["stackity"])
    Logger.any_instance.should_receive(:warn).with("Much error, many wrongs")
    Logger.any_instance.should_receive(:warn).with("> stackity")
    Logplexer.warn( ex, { verbose: true })
  end

  it 'should handle verbosity set on environment' do
    ex = Exception.new("Much error, many wrongs")
    allow(ex).to receive(:backtrace).and_return(["stackity"])
    Logger.any_instance.should_receive(:warn).with("Much error, many wrongs")
    Logger.any_instance.should_receive(:warn).with("> stackity")
    ENV['LOG_VERBOSE'] = 'true'
    Logplexer.warn( ex )
  end
  it 'should log to Honeybadger' do
    ENV['LOG_TO_HB'] = 'true'
    VCR.use_cassette('honeybadger') do
      reg = /[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}/
      expect { Logplexer.error('the error').to match( reg ) }
    end
  end
end
