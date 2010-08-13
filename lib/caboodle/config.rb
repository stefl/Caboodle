module Caboodle
  MenuItems = []
  Defaults = Hashie::Mash.new()
  Site = Defaults.clone
  RequiredSettings = Hashie::Mash.new()
  Kits = []
  Javascripts = []
  Stylesheets = []
  Site.required_settings = []
  Site.kits = [] unless Site.kits
  Defaults.merge!(Hashie::Mash.new(YAML.load_file(File.join( File.join(File.dirname(__FILE__), 'config','defaults.yml')))))
end