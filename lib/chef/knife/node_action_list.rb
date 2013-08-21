require 'chef/knife/node_action_base'

class Chef
	class Knife
		class NodeActionList < Knife

			include Chef::Knife::NodeActionBase

			banner "knife node action list SERVER_NAME (options)"

      option :all,
      :short => "-a",
      :long => "--all",
      :description => "Display all information (not just summaries) about the node actions",
      :boolean => true,
      :default => false

			def run
				# Credit to the 37signals sub project's bash-fu for providing the ready-made methods for parsing out
				# simple comment information included in the scripts and the idea to use that sort of convention in
				# the first place.
				verbose_output = %Q{
		      usage=$(sudo grep "^# Usage:" $file | cut -d ' ' -f2-)
					help="$(sudo awk '/^# Help:/,/^[^#]/' $file | grep "^#" | sed "s/^# Help: /\t/" | sed "s/^# /\t/" | sed "s/^#/\t/")"					
					echo "\n\t$usage\n"
					echo "$help\n"
				}

				cmd = %Q{
						for file in /usr/local/bin/node_actions/*; do
					    if [ ! -h $file ]; then
					      summary=$(sudo grep "^# Summary:" $file | cut -d ' ' -f3-)
								echo "$(basename $file): $summary"
								#{config[:all] ? verbose_output : ""}
					    fi
					  done
				}
				puts ""
				execute_remote cmd
				puts ""
			end
		end
	end
end