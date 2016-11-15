require "simple_role/version"
require "simple_role/config"
require "simple_role/railtie"

module SimpleRole
  def self.configure(&block)
    yield(config)
  end

  def self.config
    @_config ||= Config.new
  end
end
