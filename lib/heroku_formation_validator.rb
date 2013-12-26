require "heroku_formation_validator/version"
require "heroku_formation_validator/heroku_api"
require "yaml"
require "active_support/all"

Dir[File.join(File.dirname(__FILE__), 'heroku_formation_validator', 'plugins', '*.rb')].each do |extension|
  require extension
end

module HerokuFormationValidator
  def self.run(config_file)
    cnf = YAML::load(File.open(config_file))
    heroku_api = HerokuApi.new(cnf["auth"]["email"], cnf["auth"]["token"])
    success = true
    cnf["groups"].each do |group, validations|
      apps = validations.delete("apps")
      apps.each do |app|
        errors = []
        cnf["common"].merge(validations).each do |plugin, values|
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
