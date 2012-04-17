require 'spec_helper'
require 'capistrano/recipes/deploy/scm/bamboo'

module Capistrano::Deploy::SCM
  describe Bamboo do
    before :each do
      @bamboo = Bamboo.new
    end
  end
end
