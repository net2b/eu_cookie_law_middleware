require 'minitest_helper'

class TestEuCookieLawMiddleware < Minitest::Spec
  def test_that_it_has_a_version_number
    refute_nil ::EuCookieLawMiddleware::VERSION
  end

  def test_that_adds_the_banner
    stack = EuCookieLawMiddleware.new(simple_app)
    assert_includes collect_body(stack.call({})), 'WE USE COOKIES'
  end

  it "gets an error when trying to acces keys on the fake env" do
    template_proc = -> env { env['HTTP_HOST'] }
    assert_raises EuCookieLawMiddleware::FakeEnv do
      EuCookieLawMiddleware.new(simple_app, template_proc: template_proc)
    end
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
