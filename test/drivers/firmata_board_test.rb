require File.expand_path(File.dirname(__FILE__) + "/../test_helper")
require 'artoo/drivers/board'

describe Artoo::Drivers::Board do
  before do
    @device = mock('device')
    @board = Artoo::Drivers::Board.new(:parent => @device)
    @connection = mock('connection')
    @device.stubs(:connection).returns(@connection)
  end
    
  it 'Board#firmware_name' do
    @connection.expects(:firmware_name).returns("awesomenessware")
    @board.firmware_name.must_equal "awesomenessware"
  end

  it 'Board#version' do
    @connection.expects(:version).returns("1.2.3")
    @board.version.must_equal "1.2.3"
  end
end
