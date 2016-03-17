require 'chef/knife'

class Chef
  class Knife
    class Ssh
      def old_chef_compatible_ssh_attribute
        if self.respond_to?(:get_ssh_attribute)
          return self.get_ssh_attribute(:ssh_attribute)
        else
          self.configure_attribute
          return self.config[:ssh_attribute]
        end
      end
    end

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

        if knife_ssh.old_chef_compatible_ssh_attribute == "ipaddress"
          orig_server_name = server_name
          server_name = Chef::Node.load(server_name)[:ipaddress]

          # Ruby meta-programming magic to allow us to access via private IP address yet still print
          # using the more descriptive node name: We first get the "metaclass" of the object. This
          # ends up being equivalent to Chef::Knife::Ssh, except that changes to it only affect the
          # knife_ssh object we've created, rather than all instances of Chef::Knife::Ssh. Neat. Then
          # we make an alias to our original print_line method. Then we redefine it to not use the
          # host variable (which would end up being the ipaddress we're passing in as "server_name")
          # but rather the original server name that we passed into this command.
          knife_ssh_metaclass = class << knife_ssh; self; end
          knife_ssh_metaclass.send(:alias_method, :orig_print_line, :print_line)
          knife_ssh_metaclass.send(:define_method, :print_line) do |h, data|
            self.instance_variable_set("@longest", orig_server_name.length)
            padding = @longest - h.length
            orig_print_line(orig_server_name, data)
          end
        end

        # This isn't entirely obvious. When running Chef::Knife::Ssh this way (:manual mode), it expects
        # the server as the first argument and the actual command to run as the second.
        knife_ssh.name_args = [ server_name, cmd ]
        knife_ssh.config[:manual] = true
        knife_ssh.run
      end      
    end
  end
end