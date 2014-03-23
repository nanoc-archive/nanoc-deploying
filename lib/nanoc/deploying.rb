# encoding: utf-8

module Nanoc
  module Deploying
    module Deployers
    end
  end
end

require 'nanoc/checking'

# version
require 'nanoc/deploying/version'

# main
require 'nanoc/deploying/deployer'

# deployers
require 'nanoc/deploying/deployers/fog'
require 'nanoc/deploying/deployers/rsync'

# cli integration
require 'nanoc/deploying/cli'
