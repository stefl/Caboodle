module Caboodle
  class Debugger < Caboodle::Kit    
    Debug.each do |debug|
      Layout.below_footer = "<div id='debug'>"
      Layout.below_footer << "<p>#{debug}</p>"
      Layout.below_footer << "</div>"
    end
  end
end

