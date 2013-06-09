require 'rack/contrib/try_static'
require 'rack/contrib/not_found'
 
use Rack::TryStatic,
    :root => "_site",
    :urls => %w[/],
    :try  => ['index.md', '/index.md']
 
run lambda { [404, {'Content-Type' => 'text/html'}, ['Not Found']]}
