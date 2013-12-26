module HerokuFormationValidator
  class Runner
    attr_reader :args

    def initialize(*args)
      @args = args
      run
    end

    def self.execute(*args)
      new(*args).execute
    end

    def run
      if filename = @args[0]
        exit HerokuFormationValidator.run(filename) ? 0 : 1
      else
        puts help_text
        exit 1
      end
    end

    def help_text
      <<-help
usage: heroku_formation_validator <config file name>
help
    end
  end
end
