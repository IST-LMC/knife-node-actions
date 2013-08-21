require 'chef/knife/node_action_base'

class Chef
	class Knife
		class NodeActionRun < Knife

			include Chef::Knife::NodeActionBase

			banner "knife node action run NODE_ACTION (options)"

			def run
				server_name = @name_args[0]
				cmd = @name_args[1..-1] * " "

				puts "Running action: #{cmd}"
				
				execute_remote "sudo /usr/local/bin/node_actions/#{cmd}"
			end
		end
	end
end