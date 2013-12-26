module Heroku
  module FormationValidator
    module Plugins
      class Addons
        def self.run(heroku_api, app, values)
          errors = []
          addons = heroku_api.addons(app)
          values.each do |expected_addon|
            if !addons.detect{|addon| addon["plan"]["name"] == expected_addon}
              errors << "#{expected_addon} is not installed"
            end
          end
          errors.map{|e| "Addon: #{e}"}
        end
      end
    end
  end
end
