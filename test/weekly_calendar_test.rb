require 'test_helper'

class WeeklyCalendarTest < ActiveSupport::TestCase
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  include ActionController::TestCase::Assertions
  include WeeklyCalendar
  attr_accessor :output_buffer

  def setup
    @no_tasks = []
    @tasks = [stub(:starts_at => Time.parse("12/5/2009 8:00 AM"), :ends_at => Time.parse("12/5/2009 12:00 PM"), :name => "Test Task"),
              stub(:starts_at => Time.parse("12/5/2009 8:00 AM"), :ends_at => Time.parse("12/5/2009 12:00 PM"), :name => "Test Task2")]
  end
  
  should "raise an error if the no array is passed" do
    self.output_buffer = ''
    assert_raises(ArgumentError) do
      weekly_calendar("not an array", :date => Date.civil(2008, 12, 26), :include_24_hours => false) do |w|
      end
    end
  end
  
  should "generate links for 24 hour list" do 
    self.output_buffer = ''
    weekly_calendar(@no_tasks, :date => Date.civil(2008, 12, 26), :include_24_hours => true) do |w|
    end
    expected = %(<div id=\"week\"></div><b><a href=\"?business_hours=true&start_date=2008-12-26\">Business Hours</a> | <a href=\"?business_hours=false&start_date=2008-12-26\">24-Hours</a></b>)
    assert_dom_equal expected, output_buffer
  end
  
  should "not generate a links for 24 hour list" do 
    self.output_buffer = ''
    weekly_calendar(@no_tasks, :date => Date.civil(2008, 12, 26), :include_24_hours => false) do |w|
    end
    expected = %(<div id=\"week\"></div>)
    assert_dom_equal expected, output_buffer
  end
  
  should "generate a weekly calendar without tasks" do
    self.output_buffer = ''
    weekly_calendar(@no_tasks, :date => Date.civil(2008, 12, 26), :include_24_hours => false) do |w|
      w.week(:business_hours => true, :clickable_hours => false) do |time_slot,truncate| 
        "Test"
      end
    end
    expected = %(<div id=\"week\"><div class=\"days\" id=\"days\"><div class=\"placeholder\" id=\"placeholder\">Weekly View</div><div class=\"day\" id=\"day\" style=\"height: 75px;\"><div class=\"day-label\"><b>Friday</b><br />December 26</div></div><div class=\"day\" id=\"day\" style=\"height: 75px;\"><div class=\"day-label\"><b>Saturday</b><br />December 27</div></div><div class=\"day\" id=\"day\" style=\"height: 75px;\"><div class=\"day-label\"><b>Sunday</b><br />December 28</div></div><div class=\"day\" id=\"day\" style=\"height: 75px;\"><div class=\"day-label\"><b>Monday</b><br />December 29</div></div><div class=\"day\" id=\"day\" style=\"height: 75px;\"><div class=\"day-label\"><b>Tuesday</b><br />December 30</div></div><div class=\"day\" id=\"day\" style=\"height: 75px;\"><div class=\"day-label\"><b>Wednesday</b><br />December 31</div></div><div class=\"day\" id=\"day\" style=\"height: 75px;\"><div class=\"day-label\"><b>Thursday</b><br />January 01</div></div></div><div class=\"hours\" id=\"hours\"><div class=\"full_header_row\" id=\"full_header_row\"><div class=\"header_box\" id=\"header_box\"><b>12am</b></div><div class=\"header_box\" id=\"header_box\"><b>1am</b></div><div class=\"header_box\" id=\"header_box\"><b>2am</b></div><div class=\"header_box\" id=\"header_box\"><b>3am</b></div><div class=\"header_box\" id=\"header_box\"><b>4am</b></div><div class=\"header_box\" id=\"header_box\"><b>5am</b></div><div class=\"header_box\" id=\"header_box\"><b>6am</b></div><div class=\"header_box\" id=\"header_box\"><b>7am</b></div><div class=\"header_box\" id=\"header_box\"><b>8am</b></div><div class=\"header_box\" id=\"header_box\"><b>9am</b></div><div class=\"header_box\" id=\"header_box\"><b>10am</b></div><div class=\"header_box\" id=\"header_box\"><b>11am</b></div><div class=\"header_box\" id=\"header_box\"><b>12pm</b></div><div class=\"header_box\" id=\"header_box\"><b>1pm</b></div><div class=\"header_box\" id=\"header_box\"><b>2pm</b></div><div class=\"header_box\" id=\"header_box\"><b>3pm</b></div><div class=\"header_box\" id=\"header_box\"><b>4pm</b></div><div class=\"header_box\" id=\"header_box\"><b>5pm</b></div><div class=\"header_box\" id=\"header_box\"><b>6pm</b></div><div class=\"header_box\" id=\"header_box\"><b>7pm</b></div><div class=\"header_box\" id=\"header_box\"><b>8pm</b></div><div class=\"header_box\" id=\"header_box\"><b>9pm</b></div><div class=\"header_box\" id=\"header_box\"><b>10pm</b></div><div class=\"header_box\" id=\"header_box\"><b>11pm</b></div></div><div class=\"full_grid\" id=\"full_grid\"><div class=\"full_day_row\" id=\"full_day_row\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row\" style=\"height: 75px;\"></div></div></div></div>)
    assert_dom_equal expected, output_buffer
  end
  
  should "generate a weekly calendar with tasks" do
    self.output_buffer = ''
    weekly_calendar(@tasks, :date => Date.parse("12/02/2009 12:00 AM"), :include_24_hours => false) do |w|
      w.week(:business_hours => true, :clickable_hours => false) do |time_slot,truncate| 
        "#{time_slot.name} Test"
      end
    end
    expected = %(<div id=\"week\"><div class=\"days\" id=\"days\"><div class=\"placeholder\" id=\"placeholder\">Weekly View</div><div class=\"day\" id=\"day\" style=\"height: 75px;\"><div class=\"day-label\"><b>Wednesday</b><br />December 02</div></div><div class=\"day\" id=\"day\" style=\"height: 75px;\"><div class=\"day-label\"><b>Thursday</b><br />December 03</div></div><div class=\"day\" id=\"day\" style=\"height: 75px;\"><div class=\"day-label\"><b>Friday</b><br />December 04</div></div><div class=\"day\" id=\"day\" style=\"height: 75px;\"><div class=\"day-label\"><b>Saturday</b><br />December 05</div></div><div class=\"day\" id=\"day\" style=\"height: 75px;\"><div class=\"day-label\"><b>Sunday</b><br />December 06</div></div><div class=\"day\" id=\"day\" style=\"height: 75px;\"><div class=\"day-label\"><b>Monday</b><br />December 07</div></div><div class=\"day\" id=\"day\" style=\"height: 75px;\"><div class=\"day-label\"><b>Tuesday</b><br />December 08</div></div></div><div class=\"hours\" id=\"hours\"><div class=\"full_header_row\" id=\"full_header_row\"><div class=\"header_box\" id=\"header_box\"><b>12am</b></div><div class=\"header_box\" id=\"header_box\"><b>1am</b></div><div class=\"header_box\" id=\"header_box\"><b>2am</b></div><div class=\"header_box\" id=\"header_box\"><b>3am</b></div><div class=\"header_box\" id=\"header_box\"><b>4am</b></div><div class=\"header_box\" id=\"header_box\"><b>5am</b></div><div class=\"header_box\" id=\"header_box\"><b>6am</b></div><div class=\"header_box\" id=\"header_box\"><b>7am</b></div><div class=\"header_box\" id=\"header_box\"><b>8am</b></div><div class=\"header_box\" id=\"header_box\"><b>9am</b></div><div class=\"header_box\" id=\"header_box\"><b>10am</b></div><div class=\"header_box\" id=\"header_box\"><b>11am</b></div><div class=\"header_box\" id=\"header_box\"><b>12pm</b></div><div class=\"header_box\" id=\"header_box\"><b>1pm</b></div><div class=\"header_box\" id=\"header_box\"><b>2pm</b></div><div class=\"header_box\" id=\"header_box\"><b>3pm</b></div><div class=\"header_box\" id=\"header_box\"><b>4pm</b></div><div class=\"header_box\" id=\"header_box\"><b>5pm</b></div><div class=\"header_box\" id=\"header_box\"><b>6pm</b></div><div class=\"header_box\" id=\"header_box\"><b>7pm</b></div><div class=\"header_box\" id=\"header_box\"><b>8pm</b></div><div class=\"header_box\" id=\"header_box\"><b>9pm</b></div><div class=\"header_box\" id=\"header_box\"><b>10pm</b></div><div class=\"header_box\" id=\"header_box\"><b>11pm</b></div></div><div class=\"full_grid\" id=\"full_grid\"><div class=\"full_day_row\" id=\"full_day_row\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row\" style=\"height: 75px;\"><div class=\"week_event\" id=\"week_event\" style=\"top: 0px;left:600.0px;width:288.0px;\"></div><div class=\"week_event\" id=\"week_event\" style=\"top: 29px;left:600.0px;width:288.0px;\"></div></div><div class=\"full_day_row\" id=\"full_day_row\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row\" style=\"height: 75px;\"></div></div></div></div>)
    assert_dom_equal expected, output_buffer
    assert output_buffer.include?("<div class=\"week_event\" id=\"week_event\"")
  end
  
  should "generate a weekly calendar without tasks or a start date" do
    self.output_buffer = ''
    weekly_calendar(@no_tasks, :date => nil, :include_24_hours => false) do |w|
      w.week(:business_hours => true, :clickable_hours => false) do |time_slot,truncate| 
        "Test"
      end
    end
    assert output_buffer.include?(Date.today.strftime("%B %d"))
  end

end
