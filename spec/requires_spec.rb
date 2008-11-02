require 'rubygems'
require 'spec'

$: << File.expand_path(File.join(File.dirname(__FILE__),"..","lib"))
require 'amalgalite/requires'

describe Amalgalite::Requires do
  it "#require_order has all files in 'lib' and no more" do
    dir_files = Dir.glob( File.join( Amalgalite::Paths.lib_path , "**", "*.rb" ) )
    require_files = Amalgalite::Requires.require_order.collect { |r| Amalgalite::Paths.lib_path r }
    dir_files.size.should == require_files.size
    (dir_files - require_files).size.should == 0
    (require_files - dir_files).size.should == 0
  end

  it "can compress and uncompress data" do
    s = IO.read( __FILE__ )
    s_gz = Amalgalite::Requires.gzip( s )
    s.should == Amalgalite::Requires.gunzip( s_gz )
  end
end


