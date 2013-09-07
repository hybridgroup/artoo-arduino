require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/adaptors/littlewire'
require 'littlewire'

describe Artoo::Adaptors::Littlewire do
  before do
    @port = Artoo::Port.new('/dev/awesome')
    @adaptor = Artoo::Adaptors::Littlewire.new(:port => @port)
    @adaptor.expects(:connect_to_usb)
    @littlewire = mock('littlewire')
    LittleWire.expects(:new).returns(@littlewire)
  end

  it 'Artoo::Adaptors::Littlewire#connect' do
    @adaptor.connect.must_equal true
  end

  it 'Artoo::Adaptors::Littlewire#disconnect' do
    @littlewire.expects(:finished)
    @adaptor.connect
    @adaptor.disconnect

    @adaptor.connected?.must_equal false
  end
end
