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
    expect { Logplexer.info("Oh hai") }.to output("Oh hai").to_stdout_from_any_process
  end
end
