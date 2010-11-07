#!/usr/bin/env ruby

require 'test/unit'

require 'pidfile'

class PidFileTest < Test::Unit::TestCase
  PIDFILE="pidfile.pid"

  def setup
    File.delete(PIDFILE) if File.exist?(PIDFILE)
  end

  def teardown
    File.delete(PIDFILE) if File.exist?(PIDFILE)
  end

  def test_block_removes_pidfile
    Pid::PidFile.new(PIDFILE) do
      assert_equal(true, File.exist?(PIDFILE))
    end
    assert_equal(false, File.exist?(PIDFILE))
  end

  def test_block_blocks
    Pid::PidFile.new(PIDFILE) do
      assert_raise Pid::AlreadyRunning do
        Pid::PidFile.new(PIDFILE) {}
      end
    end
  end

  def test_set_pid
    assert_equal(true,  Pid::PidFile.set_pid(PIDFILE))
    assert_equal(true,  File.exist?(PIDFILE))
    assert_equal(false, Pid::PidFile.set_pid(PIDFILE))
  end

  def test_set_pid_and_block
    Pid::PidFile.set_pid(PIDFILE)
    assert_raise Pid::AlreadyRunning do
      Pid::PidFile.new(PIDFILE) {}
    end
  end

  def test_block_and_set_pid
    Pid::PidFile.new(PIDFILE) do
      assert_equal(false, Pid::PidFile.set_pid(PIDFILE))
    end
  end
end
