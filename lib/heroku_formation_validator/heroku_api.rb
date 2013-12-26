require "httparty"

module HerokuFormationValidator
  class HerokuApi
    include HTTParty
    base_uri 'https://api.heroku.com'
    headers({"Accept" => "application/vnd.heroku+json; version=3"})
    # debug_output $stderr

    def initialize(email, token)
      self.class.basic_auth email, token
    end

    def ping
      apps.ok?
    end

    def apps
      self.class.get("/apps")
    end

    def configvars(app_id_or_name)
      self.class.get("/apps/#{app_id_or_name}/config-vars")
    end

    def addons(app_id_or_name)
      self.class.get("/apps/#{app_id_or_name}/addons")
    end

    def logdrains(app_id_or_name)
      self.class.get("/apps/#{app_id_or_name}/log-drains")
    end
  end
end
