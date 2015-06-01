require 'minitest_helper'

class TestEuCookieLawMiddleware < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::EuCookieLawMiddleware::VERSION
  end

  def test_that_adds_the_banner
    stack = EuCookieLawMiddleware.new(simple_app)
    assert_includes collect_body(stack.call({})), 'WE USE COOKIES'
  end


  private

  def collect_body(response)
    body = ''
    response.last.each {|part| body << part}
    body
  end

  def simple_app
    -> env {[200, {'Content-Type' => 'text/html'}, '<body>hello</body>']}
  end
end
