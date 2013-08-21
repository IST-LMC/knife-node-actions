# Knife::Node::Actions

Treat your running servers like you'd treat objects in a program! This plugin is a very simple first attempt at setting up a framework for adding "actions" to nodes that can be listed and run from a knife command. It looks in /usr/local/bin/node_actions and lists any script found within as an action for that node. If the scripts themselves follow some simple commenting conventions, borrowed from 37signals' awesome sub project (see: https://github.com/37signals/sub#self-documenting-subcommands), these will be shown to anyone listing actions from the knife command.

## Installation

Add this line to your application's Gemfile:

    gem 'knife-node-actions'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install knife-node-actions

## Usage

```console
	knife node action list NODE_NAME
```

List all actions that can be run on the given node, along with their summaries.

```console
	knife node action list NODE_NAME --all
```

List all actions that can be run on the given node, along with more detailed description (including help and usage magic comments).

```console
	knife node action run NODE_NAME ACTION_NAME [ACTION_PARAMETERS]
```

Run an action on a node.

## Script Conventions

```
	# Summary: This will show up in any listing of actions beside the action name.
	# Usage: This will show up when the --all flag is added to a node listing.
	# Help: This will also show up when the --all flag is added to a node action listing.
	# Any regular comment under the initial "Help" comment will also show up, on a new line,
	# under a node action listing with the --all flag.
```

## Why?

Chef makes it really easy to generate wrapper scripts to use more complicated tools with the right parameters for a particular action on a particular server. This allows you to bake complex knowledge into simple actions that can be carried out on the server. For example, instead of a section with boilerplate commands in your on call documentation on how to initialize a PostgreSQL standby server in the "correct" way (likely at least slightly different for every organization), turn the initialization into a template script and install it directly on the server with all the necessary parameters baked in. Thus, a person wanting to intialize the standby would just have to run:

```console
	knife node action run standby-server initialize-standby
```

We've been using this template-wrapper script pattern for a while, and it has made tasks like these much easier for everyone to carry out (and anyone who needs to know what is actually happening under the hood can read the associated script). However, there have also been times like this:

DevOps 1: Uggh! I just finished figuring out how to initialize this PostgreSQL standby server!
DevOps 2: Really? Why didn't you just use the script I made for that on the server?
DevOps 1: There was a script on the server already?
DevOps 2: I mentioned that on IRC, but I guess I should have put it somewhere more permanent.

Basically, you build these wonderful tools to make your life easier, but people have to know about them. This follows the principle of getting this sort of documentation as close to the source as possible. If you adopt the convention of putting any "action" scripts in /usr/local/bin/node_actions and your team members know they can see what pre-baked actions are available on a node via: "knife node action list your-node-name", then hopefully it's a lot more difficult for the above situation to happen.

## Contributing

This is a very early stages idea and a very rudimentary tool. Feedback is more than welcome.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
