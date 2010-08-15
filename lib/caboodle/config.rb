module Caboodle  
  Kits             = []
  MenuItems        = []
  Javascripts      = []
  Stylesheets      = []
  RSS              = []
  
  Defaults         = Hashie::Mash.new(Hashie::Mash.new(YAML.load_file(File.join(File.dirname(__FILE__), 'config','defaults.yml'))))
  RequiredSettings = Hashie::Mash.new()
  Layout           = Hashie::Mash.new()
  Site             = Defaults.clone
  
  Site.required_settings = []
  Site.kits = [] unless Site.kits
end