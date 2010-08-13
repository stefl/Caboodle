module Caboodle
  class Analytics < Caboodle::Kit
    add_to_layout "after_body" => "<script type=\"text/javascript\">
    	var gaJsHost = ((\"https:\" == document.location.protocol) ? \"https://ssl.\" : \"http://www.\");
    	document.write(unescape(\"%3Cscript src='\" + gaJsHost + \"google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E\"));
    </script>
    <script type=\"text/javascript\">
    	try {
    	var pageTracker = _gat._getTracker(\"#{Caboodle::Site.analytics_id}\");
    	pageTracker._trackPageview();
    	} catch(err) {}
    </script>"
    required [:analytics_id]
  end
end