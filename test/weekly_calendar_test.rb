require File.dirname(__FILE__) + '/test_helper.rb'

class WeeklyCalendarTest < Test::Unit::TestCase
  def test_builder_throws_argument_error_when_sending_wrong_parameter_type
    assert_raise(ArgumentError) { WeeklyCalendar::Builder.new(1, nil, nil, nil, nil) }
  end
end
