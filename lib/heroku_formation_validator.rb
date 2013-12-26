require "heroku_formation_validator/version"
require "yaml"
require "active_support/all"
require "heroku_formation_validator/heroku_api"

Dir[File.join(File.dirname(__FILE__), 'heroku_formation_validator', 'plugins', '*.rb')].each do |extension|
  require extension
end

module HerokuFormationValidator
  def self.run(config_file, environment="test")
    cnf = YAML::load(File.open(config_file))[environment]
    common = cnf["common"]
    heroku_api = HerokuApi.new
    success = true
    cnf["groups"].each do |group, validations|
      apps = validations.delete("apps")
      apps.each do |app|
        errors = []
        common.merge(validations).each do |plugin, values|
          plugin = "HerokuFormationValidator::Plugins::#{plugin.to_s.camelize}".safe_constantize
          errors += plugin.run(heroku_api, app, values)
        end

        if errors.length > 0
          success = false
          puts "=== #{group} #{app}"
          puts errors.join("\n")
        end
      end
    end
    success
  end
end
