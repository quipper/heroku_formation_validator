module HerokuFormationValidator
  module Plugins
    class Papertrail
      def self.run(heroku_api, app, values)
        errors = []
        drains = heroku_api.logdrains(app)
        unless drains.detect{|drain| drain["url"] =~ /^syslog:\/\/logs.papertrailapp.com/}
          errors << "not set in logdrains"
        end
        errors
      end
    end
  end
end
