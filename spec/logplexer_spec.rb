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

  it 'should log to Honeybadger' do
    ENV['LOG_TO_HB'] = 'true'
    VCR.use_cassette('honeybadger') do
      reg = /[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}/
      expect { Logplexer.error('the error').to match( reg ) }
    end
  end
end
