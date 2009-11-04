# Include hook code here
require 'acts_as_sphinx_results'
ActionController::Base.class_eval do
  include ActsAsSphinxResults
end
