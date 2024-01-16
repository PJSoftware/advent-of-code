class Test
  def initialize()
    @run = 0
    @failed = 0
  end

  def test(label, exp, got)
    @run += 1
    if got == exp
      puts "OK -- '#{label}' => #{got} / passed"
    else
      puts "FAIL -- '#{label}' failed;\n  - exp '#{exp}';\n  - got '#{got}'"
      @failed += 1
    end
  end

  def bail_on_fail
    if @failed > 0
      puts "\nSample Data Tests: #{@failed}/#{@run} failed"
      exit(1)
    end
  end

end
