require "spec_helper"
require "stringio"

describe HerokuFormationValidator do
  describe ".error" do
    around do |ex|
      $stderr = StringIO.new
      ex.run
      $stderr = STDERR
    end

    it "should aroud given message by escape sequence" do
      HerokuFormationValidator.error("Error!")
      expect($stderr.string.chomp).to eq "\e[31mError!\e[0m"
    end
  end
end
