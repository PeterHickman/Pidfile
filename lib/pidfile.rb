# Allows a program to use a pid file to make sure that only one 
# instance of a program is being run at a time.
#
# This can be done in two ways:
#
#  require 'pidfile'
# 
#  unless Pid::PidFile.set_pid("/var/run/app.pid")
#    puts "This process is already running!"
#    exit
#  end
# 
#  ...the rest of your program goes here
#
# Or you can call this in a more Rubyish way:
#
#  require 'pidfile'
#
#  begin
#    Pid::PidFile.new("/var/run/app.pid") do
#      ...the rest of your program goes here
#    end
#  rescue Pid::AlreadyRunning => e
#    puts "This process is already running!"
#    exit
#  end

module Pid
  class PidFile
    VERSION='1.0.0'

    def initialize(filename, &code)
      raise AlreadyRunning.new unless PidFile.set_pid(filename)

      code.call

      File.delete(filename)
    end

    def self.set_pid(filename)
      if File.exist?(filename)
        File.open(filename, "r").each do |l|
          old_pid = l.chomp.to_i

          begin
            Process.kill(0, old_pid)
            # The process is running
            return false
          rescue Errno::EPERM
            # The process is running and you don't have permission
            return false
          rescue
            # the process is not running or something
          end
        end

        File.delete(filename)
      end

      # Create the new process
      f = File.new(filename, "w")
      f.puts $$
      f.close
  
      return true
    end
  end

  class AlreadyRunning < Exception
  end
end
