require 'eu_cookie_law_middleware/version'
require 'erb'
require 'uri'

# From the original: https://github.com/libin/rack-smart-app-banner
# MIT Licensed
class EuCookieLawMiddleware
  def initialize(app, options = {})
    @app, @options = app, options
    @reload_code = options.fetch(:reload_code, false)
    @template = Pathname(options.fetch(:template_path) {
      File.join(__dir__, 'eu_cookie_law_middleware', 'template.erb')
    })
    get_code # warmup
  end

  def cookie_name
    'dismiss_cookie_law'.freeze
  end

  def call(env)
    return @app.call(env) if (env['rack.request.cookie_hash'] || {}).has_key?(cookie_name)

    status, headers, body = @app.call(env)
    return [status, headers, body] if !(html?(headers)) or status != 200

    request = Rack::Request.new(env)
    response = Rack::Response.new([], status, headers)
    code = get_code

    body = [body] if String === body
    body.each { |fragment| response.write inject_code(code, fragment) }
    body.close if body.respond_to? :close

    response.finish
  end

  private

  def html?(headers)
    headers["Content-Type"] =~ /html/
  end

  def get_code
    @@code = nil if @reload_code
    @@code ||= ERB.new(@template.read).result(binding)
  end

  def js_cookie_code
    %{document.cookie = "#{cookie_name}=true; expires=Fri, 31 Dec 9999 23:59:59 GMT; path=/";}
  end

  def inject_code(code, fragment)
    fragment.sub(%r{</body>}, code + "</body>")
  end
end
