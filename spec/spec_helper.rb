require 'rubygems'
require 'spec'

$: << File.expand_path(File.join(File.dirname(__FILE__),"..","lib"))

require 'amalgalite'
require File.expand_path( File.join( File.dirname(__FILE__), "iso_3166_database.rb" )  )

class SpecInfo
  class << self
    def test_db
      @test_db ||=  File.expand_path(File.join(File.dirname(__FILE__), "data", "test.db"))
    end

    def make_master_iso_db
      @master_db ||= Amalgalite::Iso3166Database.new
    end

    def make_clone_iso_db
      new_path = make_master_iso_db.duplicate( 'testing' )
    end
  end
end

Spec::Runner.configure do |config|
  config.before(:all) do 
    SpecInfo.make_master_iso_db
  end

  config.after(:all) do
    File.unlink( Amalgalite::Iso3166Database.default_db_file ) if File.exist?( Amalgalite::Iso3166Database.default_db_file )
  end

  config.before( :each ) do
    @iso_db_path = SpecInfo.make_clone_iso_db
    @iso_db      = Amalgalite::Database.new( @iso_db_path )
    @schema     = IO.read( Amalgalite::Iso3166Database.schema_file )
  end

  config.after( :each ) do
    @iso_db.close
    File.unlink( @iso_db_path ) if File.exist?( @iso_db_path )
    File.unlink( SpecInfo.test_db ) if File.exist?( SpecInfo.test_db )
  end
end

