require 'attest/output/output_writer'

this_tests "output writer base class" do 
  before_each {@output_writer = Attest::Output::OutputWriter.new}
  test("should format as milliseconds when elapsed time is less than 1 second") do
    should_equal("12 milliseconds", @output_writer.elapsed_time(0.012, 0))
  end
  test("should format as seconds when elapsed time less than 60 seconds") do 
    should_equal("1.3 seconds", @output_writer.elapsed_time(1.3, 0))
    should_equal("22.05 seconds", @output_writer.elapsed_time(22.06, 0.01))
  end
  test("should format as minutes and seconds when elapsed time is less than 1 hour but more than 1 minute") do
    should_equal("1 minutes, 22.05 seconds", @output_writer.elapsed_time(82.06, 0.01))
    should_equal("59 minutes, 22.05 seconds", @output_writer.elapsed_time(3562.06, 0.01))
  end
  test("should format as hours, minutes and seconds when elapsed time is over an hour") do
    should_equal("1 hours, 0 minutes, 0 seconds", @output_writer.elapsed_time(3600.01, 0.01))
    should_equal("1 hours, 59 minutes, 22.05 seconds", @output_writer.elapsed_time(7162.06, 0.01))
  end
end
