require 'chef/knife'

class Chef
  class Knife
    module NodeActionBase
			def self.included(includer)
        includer.class_eval do
					deps do
		        require 'net/ssh'
		        require 'net/ssh/multi'
		        require 'chef/knife/ssh'
		        require 'chef/mixin/command'
		      end
		    end
		  end

    	def execute_remote(cmd)
    		# See the Chef::Knife::Bootstrap class for another example on how to reuse Chef::Knife::Ssh.
    		# This is a simplified version of that example, which counts on the run method to initialize
    		# values appropriately from the configuration.
    		server_name = Array(@name_args).first

				knife_ssh = Chef::Knife::Ssh.new
				# This isn't entirely obvious. When running Chef::Knife::Ssh this way (:manual mode), it expects 
				# the server as the first argument and the actual command to run as the second.
				knife_ssh.name_args = [ server_name, cmd ]
				knife_ssh.config[:manual] = true
				knife_ssh.run
    	end
    end
  end
end