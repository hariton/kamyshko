class SourceSweeper < ActionController::Caching::Sweeper
  observe Source, Issue

  def expire_sources(record)
    expire_fragment(:controller => 'home', :action => 'index', :fragment => 'sources')
  end

  alias :after_create  :expire_sources
  alias :after_update  :expire_sources
  alias :after_destroy :expire_sources

end
