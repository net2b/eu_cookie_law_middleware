require 'rack'
require 'eu_cookie_law_middleware/version'
require 'erb'
require 'uri'

# From the original: https://github.com/libin/rack-smart-app-banner
# MIT Licensed
class EuCookieLawMiddleware
  def initialize(app, options = {})
    @app, @options = app, options
    @reload_code = options.fetch(:reload_code, false)
    @template_proc = extract_template_proc(options)
    @code = generate_html unless @reload_code
  end

  def cookie_name
    'dismiss_cookie_law'.freeze
  end

  def call(env)
    original_response = @app.call(env)
    status, headers, body  = original_response

    if status != 200 or not_html?(headers) or has_dismissed?(env)
      return original_response
    end

    response = Rack::Response.new([], status, headers)
    code = @code || generate_html(env: env)

    body = [body] if String === body
    body.each { |fragment| response.write inject_code(code, fragment) }
    body.close if body.respond_to? :close

    response.finish
  end


  private

  def generate_html(env: {}, binding: binding)
    ERB.new(@template_proc.call(env)).result(binding)
  end

  def has_dismissed?(env)
    request = Rack::Request.new(env)
    request.cookies.has_key?(cookie_name)
  end

  def extract_template_proc(options)
    options.fetch(:template_proc) do
      default_path = File.join(__dir__, 'eu_cookie_law_middleware', 'template.erb')
      pathname = Pathname(options.fetch(:template_path, default_path))
      if @reload_code
        contents = pathname.read
        -> { contents }
      else
        -> { pathname.read }
      end
    end
  end

  def not_html?(headers)
    headers["Content-Type"] =~ /html/
  end

  def js_cookie_code
    %{document.cookie = "#{cookie_name}=true; expires=Fri, 31 Dec 9999 23:59:59 GMT; path=/";}
  end

  def inject_code(code, fragment)
    fragment.sub(%r{</body>}, code + "</body>")
  end
end
