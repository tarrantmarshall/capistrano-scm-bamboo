# capistrano-scm-bamboo

With this plugin, you can use Atlassian Bamboo build artifacts as a repository, 
and deploy your build with Capistrano.

## INSTALL

    gem install capistrano-scm-bamboo

## USAGE

Sample extract from config/deploy.rb

    require 'capistrano-scm-bamboo'
	
	set :application, "example"
	
	set :scm, bamboo
	set :repository, "http://bamboo.local/rest/api/latest"
	
    set :scm_username, ENV['CAP_BUILD_USER'] || "build"
    set :scm_passphrase, ENV['CAP_BUILD_PASS'] || Proc.new { Capistrano::CLI.password_prompt("Please enter the Bamboo password for '#{scm_username}': ") }
	
	# If calling Cap from within Bamboo, these can be passed via -s options on the Cap call itself to override
    set :plan_key, "PROJECT-PLAN"
    set :build_number, "latest"
    set :artifact, "artifact"
	
## LICENSE

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
