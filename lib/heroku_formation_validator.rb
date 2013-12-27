require "heroku_formation_validator/version"
require "heroku_formation_validator/heroku_api"
require "heroku_formation_validator/runner"
require "yaml"
require "active_support/all"
require "rainbow"

Dir[File.join(File.dirname(__FILE__), 'heroku_formation_validator', 'plugins', '*.rb')].each do |extension|
  require extension
end

module HerokuFormationValidator
  def self.run(config_file)
    begin
      cnf = YAML::load(File.open(config_file))
    rescue Errno::ENOENT
      error "File not found: #{config_file}"
      return false
    end
    heroku_api = HerokuApi.new(cnf["auth"]["email"], cnf["auth"]["token"])

    unless heroku_api.ping
      error "Heroku API error. Heroku credential in config is not correct?"
      return false
    end

    success = true
    cnf["groups"].each do |group, validations|
      apps = validations.delete("apps")
      apps.each do |app|
        errors = []
        cnf["common"].merge(validations).each do |plugin, values|
          plugin_klass = "HerokuFormationValidator::Plugins::#{plugin.camelize}".safe_constantize
          errors += plugin_klass.run(heroku_api, app, values).map{|error| "#{plugin.camelize}: #{error}"}
        end

        if errors.length > 0
          success = false
          error "=== #{group} #{app} ==="
          error errors.join("\n")
        end
      end
    end
    success
  end

  def self.error(msg)
    $stderr.puts msg.color(:red)
  end
end
