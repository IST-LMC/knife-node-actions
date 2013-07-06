# -*- encoding: utf-8 -*-
require File.expand_path('../lib/knife-node-actions/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Ackerman"]
  gem.email         = ["david.s.ackerman@gmail.com"]
  gem.description   = %q{List and run actions available to a node}
  gem.summary       = %q{List and run actions available to a node}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "knife-node-actions"
  gem.require_paths = ["lib"]
  gem.version       = Knife::Node::Actions::VERSION
end
