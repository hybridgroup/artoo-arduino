require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/firmata_board'

describe Artoo::Drivers::FirmataBoard do
  before do
    @device = mock('device')
    @board = Artoo::Drivers::FirmataBoard.new(:parent => @device)
    @connection = mock('connection')
    @device.stubs(:connection).returns(@connection)
  end
    
  it 'FirmataBoard#firmware_name' do
    @connection.expects(:firmware_name).returns("awesomenessware")
    @board.firmware_name.must_equal "awesomenessware"
  end

  it 'FirmataBoard#version' do
    @connection.expects(:version).returns("1.2.3")
    @board.version.must_equal "1.2.3"
  end
end
