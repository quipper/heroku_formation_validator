require "heroku_formation_validator/version"
require "heroku_formation_validator/heroku_api"
require "heroku_formation_validator/runner"
require "yaml"
require "active_support/all"

Dir[File.join(File.dirname(__FILE__), 'heroku_formation_validator', 'plugins', '*.rb')].each do |extension|
  require extension
end

module HerokuFormationValidator
  def self.run(config_file)
    begin
      cnf = YAML::load(File.open(config_file))
    rescue Errno::ENOENT
      $stderr.puts "File not found: #{config_file}"
      return false
    end
    heroku_api = HerokuApi.new(cnf["auth"]["email"], cnf["auth"]["token"])

    unless heroku_api.ping
      $stderr.puts "Heroku API error. Heroku credential in config is not correct?"
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
          $stderr.puts "=== #{group} #{app} ==="
          $stderr.puts errors.join("\n")
        end
      end
    end
    success
  end
end
