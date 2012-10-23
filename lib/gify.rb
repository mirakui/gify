require_relative 'gify/gif'
require_relative 'gify/thor_starter'
require_relative 'gify/version'

module Gify
  module_function
  def config
    @config ||= {}
  end
end
