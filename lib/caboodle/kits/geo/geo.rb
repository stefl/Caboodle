require 'rack-geo'

class Caboodle::Geo < Caboodle::Kit
  optional [:zip, :postcode, :address, :latitude, :longitude]
  
  before do
    @latitude, @longitude, @uncertainty = 37.0625, -95.677068, 100
    @coords = "#{@latitude};#{@longitude} epu=#{@uncertainty}"
    headers "HTTP_GEO_POSITION" => @coords
  end    
  
end