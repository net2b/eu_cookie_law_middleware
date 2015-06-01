require 'minitest_helper'

class TestEuCookieLawMiddleware < Minitest::Spec
  it 'has a version number' do
    refute_nil ::EuCookieLawMiddleware::VERSION
  end

  it 'adds the banner' do
    stack = EuCookieLawMiddleware.new(simple_app)
    assert_includes collect_body(stack.call({})), 'WE USE COOKIES'
  end

  it "raises when trying to acces keys on the fake env" do
    template_proc = -> env { env['HTTP_HOST'] }
    assert_raises EuCookieLawMiddleware::FakeEnv do
      EuCookieLawMiddleware.new(simple_app, template_proc: template_proc)
    end
  end

  it "raises when passed a proc without env arg" do
    template_proc = -> {  }
    assert_raises ArgumentError do
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
