module Heroku
  module FormationValidator
    module Plugins
      class Variables

        def self.run(heroku_api, app, values)
          errors = []
          config = heroku_api.configvars(app)
          values.each do |key, value|
            if value.nil?
              if config.has_key?(key)
                errors << "#{key} is defined"
              end
            elsif !config.has_key?(key)
              errors << "#{key} is not defined"
            else config[key] != value
              errors << "#{key} doesn't match. expected \"#{value}\" but \"#{config[key]}\""
            end
          end
          errors.map{|e| "Variable: #{e}"}
        end
      end
    end
  end
end
