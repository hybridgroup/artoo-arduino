require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/littlewire'
require 'littlewire'

describe Artoo::Adaptors::LittleWire do
  before do
    @port = Artoo::Port.new('/dev/awesome')
    @adaptor = Artoo::Adaptors::LittleWire.new(:port => @port)
    @littlewire = mock('littlewire')
    LittleWire.expects(:new).returns(@littlewire)
  end

  it 'Artoo::Adaptors::LittleWire#connect' do
    @adaptor.connect.must_equal true
  end

  it 'Artoo::Adaptors::LittleWire#disconnect' do
    @littlewire.expects(:finished)
    @adaptor.connect
    @adaptor.disconnect

    @adaptor.connected?.must_equal false
  end
end
