module HerokuFormationValidator
  module Plugins
    class Variables

      def self.run(heroku_api, app, values)
        errors = []
        config = heroku_api.configvars(app)
        values.each do |key, value|
          if value.nil?
            if config.has_key?(key)
              errors << "\"#{key}\" is defined"
            end
          elsif !config.has_key?(key)
            errors << "\"#{key}\" is not defined"
          elsif config[key] != value
            errors << "\"#{key}\" doesn't match. expected \"#{value}\" but \"#{config[key]}\""
          end
        end
        errors
      end
    end
  end
end
