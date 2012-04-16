require 'rubygems'
require 'test/unit'
require 'active_support'
require 'active_record'
require 'active_record/fixtures'

ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'
require File.expand_path(File.join(ENV['RAILS_ROOT'], 'config/environment.rb'))

begin
  require 'ruby-debug'
  Debugger.start
  if Debugger.respond_to?(:settings)
    Debugger.settings[:autoeval] = true
    Debugger.settings[:autolist] = 1
  end
  rescue LoadError
  # ruby-debug wasn't available so neither can the debugging be
end


def load_schema

  config = YAML::load(IO.read(File.dirname(__FILE__) + '/fixtures/database.yml'))
  db_adapter = 'mysql2'

  ActiveRecord::Base.establish_connection(config[db_adapter])
  load(File.dirname(__FILE__) + "/fixtures/schema.rb")
  load(File.dirname(__FILE__) + "/fixtures/data_model.rb")

  Fixtures.create_fixtures(File.expand_path('test/fixtures'), ActiveRecord::Base.connection.tables.select{|t| t!= "schema_migrations"})

end

