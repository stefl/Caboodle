module Caboodle  
  Kits = []
  MenuItems = []
  Javascripts = []
  Stylesheets = []
  Defaults = Hashie::Mash.new()
  RequiredSettings = Hashie::Mash.new()
  Site = Defaults.clone
  Site.required_settings = []
  Site.kits = [] unless Site.kits
  Defaults.merge!(Hashie::Mash.new(YAML.load_file(File.join( File.join(File.dirname(__FILE__), 'config','defaults.yml')))))
end