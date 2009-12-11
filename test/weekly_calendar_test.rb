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
    @mixed_tasks = [stub(:starts_at => Time.parse("12/5/2009 8:00 AM"), :ends_at => Time.parse("12/5/2009 12:00 PM"), :name => "Test Task"),
                    stub(:starts_at => Time.parse("12/5/2009 8:00 AM"), :ends_at => Time.parse("12/5/2009 12:00 PM"), :name => "Test Task2"),
                    stub(:starts_at => Time.parse("12/5/2009 00:00 AM"), :ends_at => Time.parse("12/5/2009 11:59 PM"), :name => "Test Task2"),
                    stub(:starts_at => Time.parse("12/5/2009 00:00 AM"), :ends_at => Time.parse("12/5/2009 11:59 PM"), :name => "Test Task2")]
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
    expected = %(<div id=\"week\">)<<
                  %(<div class=\"days\" id=\"days\">)<<
                    %(<div class=\"placeholder\" id=\"placeholder\">Week</div>)                                                                  <<
                      %(<div class=\"day\" id=\"day_0\" style=\"height: 75px;\"><div class=\"day-label\"><b>Fri</b><br />12/26</div></div>)      <<
                      %(<div class=\"day\" id=\"day_1\" style=\"height: 75px;\"><div class=\"day-label\"><b>Sat</b><br />12/27</div></div>)    <<
                      %(<div class=\"day\" id=\"day_2\" style=\"height: 75px;\"><div class=\"day-label\"><b>Sun</b><br />12/28</div></div>)      <<
                      %(<div class=\"day\" id=\"day_3\" style=\"height: 75px;\"><div class=\"day-label\"><b>Mon</b><br />12/29</div></div>)      <<
                      %(<div class=\"day\" id=\"day_4\" style=\"height: 75px;\"><div class=\"day-label\"><b>Tue</b><br />12/30</div></div>)     <<
                      %(<div class=\"day\" id=\"day_5\" style=\"height: 75px;\"><div class=\"day-label\"><b>Wed</b><br />12/31</div></div>)   <<
                      %(<div class=\"day\" id=\"day_6\" style=\"height: 75px;\"><div class=\"day-label\"><b>Thu</b><br />01/01</div></div>)     <<
                    %(</div><div class=\"all_day_events\" id=\"all_day_events\"><div class=\"placeholder\" id=\"all-day-placeholder\">All Day</div>)    <<
                      %(<div class=\"days_tasks\" id=\"days_tasks_0\" style=\"height: 75px;\"></div>)                                                     <<
                      %(<div class=\"days_tasks\" id=\"days_tasks_1\" style=\"height: 75px;\"></div>)                                                     <<
                      %(<div class=\"days_tasks\" id=\"days_tasks_2\" style=\"height: 75px;\"></div>)                                                     <<
                      %(<div class=\"days_tasks\" id=\"days_tasks_3\" style=\"height: 75px;\"></div>)                                                     <<
                      %(<div class=\"days_tasks\" id=\"days_tasks_4\" style=\"height: 75px;\"></div>)                                                     <<
                      %(<div class=\"days_tasks\" id=\"days_tasks_5\" style=\"height: 75px;\"></div>)                                                     <<
                      %(<div class=\"days_tasks\" id=\"days_tasks_6\" style=\"height: 75px;\"></div>)                                                     <<
                    %(</div><div class=\"hours\" id=\"hours\">)                                                                                         <<
                    %(<div class=\"full_header_row\" id=\"full_header_row\">)                                                                           <<
                      %(<div class=\"header_box\" id=\"header_box_0\"><b>12am</b></div>)                                                                  <<
                      %(<div class=\"header_box\" id=\"header_box_1\"><b>1am</b></div>)                                                                   <<
                      %(<div class=\"header_box\" id=\"header_box_2\"><b>2am</b></div>)                                                                   <<
                      %(<div class=\"header_box\" id=\"header_box_3\"><b>3am</b></div>)                                                                   <<
                      %(<div class=\"header_box\" id=\"header_box_4\"><b>4am</b></div>)                                                                   <<
                      %(<div class=\"header_box\" id=\"header_box_5\"><b>5am</b></div>)                                                                   <<
                      %(<div class=\"header_box\" id=\"header_box_6\"><b>6am</b></div>)                                                                   <<
                      %(<div class=\"header_box\" id=\"header_box_7\"><b>7am</b></div>)                                                                   <<
                      %(<div class=\"header_box\" id=\"header_box_8\"><b>8am</b></div>)                                                                   <<
                      %(<div class=\"header_box\" id=\"header_box_9\"><b>9am</b></div>)                                                                   <<
                      %(<div class=\"header_box\" id=\"header_box_10\"><b>10am</b></div>)                                                                 <<
                      %(<div class=\"header_box\" id=\"header_box_11\"><b>11am</b></div>)                                                                 <<
                      %(<div class=\"header_box\" id=\"header_box_12\"><b>12pm</b></div>)                                                                 <<
                      %(<div class=\"header_box\" id=\"header_box_13\"><b>1pm</b></div>)                                                                  <<
                      %(<div class=\"header_box\" id=\"header_box_14\"><b>2pm</b></div>)                                                                  <<
                      %(<div class=\"header_box\" id=\"header_box_15\"><b>3pm</b></div>)                                                                  <<
                      %(<div class=\"header_box\" id=\"header_box_16\"><b>4pm</b></div>)                                                                  <<
                      %(<div class=\"header_box\" id=\"header_box_17\"><b>5pm</b></div>)                                                                  <<
                      %(<div class=\"header_box\" id=\"header_box_18\"><b>6pm</b></div>)                                                                  <<
                      %(<div class=\"header_box\" id=\"header_box_19\"><b>7pm</b></div>)                                                                  <<
                      %(<div class=\"header_box\" id=\"header_box_20\"><b>8pm</b></div>)                                                                  <<
                      %(<div class=\"header_box\" id=\"header_box_21\"><b>9pm</b></div>)                                                                  <<
                      %(<div class=\"header_box\" id=\"header_box_22\"><b>10pm</b></div>)                                                                 <<
                      %(<div class=\"header_box\" id=\"header_box_23\"><b>11pm</b></div>)                                                                 <<
                    %(</div><div class=\"full_grid\" id=\"full_grid\">)                                                                                 <<
                      %(<div class=\"full_day_row\" id=\"full_day_row_0\" style=\"height: 75px;\"></div>)                                                 <<
                      %(<div class=\"full_day_row\" id=\"full_day_row_1\" style=\"height: 75px;\"></div>)                                                 <<
                      %(<div class=\"full_day_row\" id=\"full_day_row_2\" style=\"height: 75px;\"></div>)                                                 <<
                      %(<div class=\"full_day_row\" id=\"full_day_row_3\" style=\"height: 75px;\"></div>)                                                 <<
                      %(<div class=\"full_day_row\" id=\"full_day_row_4\" style=\"height: 75px;\"></div>)                                                 <<
                      %(<div class=\"full_day_row\" id=\"full_day_row_5\" style=\"height: 75px;\"></div>)                                                 <<
                      %(<div class=\"full_day_row\" id=\"full_day_row_6\" style=\"height: 75px;\"></div>)                                                 <<
                    %(</div></div></div>)
                                                            
    assert_dom_equal expected, output_buffer
  end
  
  should "generate a weekly calendar without tasks that indicates today's date" do
    self.output_buffer = ''
    weekly_calendar(@no_tasks, :date => Date.today, :include_24_hours => false) do |w|
      w.week(:business_hours => true, :clickable_hours => false) do |time_slot,truncate| 
        "Test"
      end
    end            
    assert output_buffer.include?("<div class=\"day today\" "), "The output should have a div with a class for today."
    assert output_buffer.include?("<div class=\"days_tasks today\" "), "The output should have a div with a class for today."
  end
  
  should "generate a weekly business day calendar without tasks" do
    self.output_buffer = ''
    weekly_calendar(@no_tasks, :date => Date.civil(2008, 12, 26), :include_24_hours => false) do |w|
      w.week(:business_hours => false, :clickable_hours => false) do |time_slot,truncate| 
        "Test"
      end
    end
    expected = %(<div id=\"week\"><div class=\"days\" id=\"days\"><div class=\"placeholder\" id=\"placeholder\">Week</div><div class=\"day\" id=\"day_0\" style=\"height: 75px;\"><div class=\"day-label\"><b>Fri</b><br />12/26</div></div><div class=\"day\" id=\"day_1\" style=\"height: 75px;\"><div class=\"day-label\"><b>Sat</b><br />12/27</div></div><div class=\"day\" id=\"day_2\" style=\"height: 75px;\"><div class=\"day-label\"><b>Sun</b><br />12/28</div></div><div class=\"day\" id=\"day_3\" style=\"height: 75px;\"><div class=\"day-label\"><b>Mon</b><br />12/29</div></div><div class=\"day\" id=\"day_4\" style=\"height: 75px;\"><div class=\"day-label\"><b>Tue</b><br />12/30</div></div><div class=\"day\" id=\"day_5\" style=\"height: 75px;\"><div class=\"day-label\"><b>Wed</b><br />12/31</div></div><div class=\"day\" id=\"day_6\" style=\"height: 75px;\"><div class=\"day-label\"><b>Thu</b><br />01/01</div></div></div><div class=\"all_day_events\" id=\"all_day_events\"><div class=\"placeholder\" id=\"all-day-placeholder\">All Day</div><div class=\"days_tasks\" id=\"days_tasks_0\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_1\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_2\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_3\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_4\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_5\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_6\" style=\"height: 75px;\"></div></div><div class=\"hours\" id=\"hours\"><div class=\"header_row\" id=\"header_row\"><div class=\"header_box\" id=\"header_box_0\"><b>6am</b></div><div class=\"header_box\" id=\"header_box_1\"><b>7am</b></div><div class=\"header_box\" id=\"header_box_2\"><b>8am</b></div><div class=\"header_box\" id=\"header_box_3\"><b>9am</b></div><div class=\"header_box\" id=\"header_box_4\"><b>10am</b></div><div class=\"header_box\" id=\"header_box_5\"><b>11am</b></div><div class=\"header_box\" id=\"header_box_6\"><b>12pm</b></div><div class=\"header_box\" id=\"header_box_7\"><b>1pm</b></div><div class=\"header_box\" id=\"header_box_8\"><b>2pm</b></div><div class=\"header_box\" id=\"header_box_9\"><b>3pm</b></div><div class=\"header_box\" id=\"header_box_10\"><b>4pm</b></div><div class=\"header_box\" id=\"header_box_11\"><b>5pm</b></div><div class=\"header_box\" id=\"header_box_12\"><b>6pm</b></div><div class=\"header_box\" id=\"header_box_13\"><b>7pm</b></div><div class=\"header_box\" id=\"header_box_14\"><b>8pm</b></div></div><div class=\"grid\" id=\"grid\"><div class=\"day_row\" id=\"day_row_0\" style=\"height: 75px;\"></div><div class=\"day_row\" id=\"day_row_1\" style=\"height: 75px;\"></div><div class=\"day_row\" id=\"day_row_2\" style=\"height: 75px;\"></div><div class=\"day_row\" id=\"day_row_3\" style=\"height: 75px;\"></div><div class=\"day_row\" id=\"day_row_4\" style=\"height: 75px;\"></div><div class=\"day_row\" id=\"day_row_5\" style=\"height: 75px;\"></div><div class=\"day_row\" id=\"day_row_6\" style=\"height: 75px;\"></div></div></div></div>)                                                          
    assert_dom_equal expected, output_buffer
  end
  
  should "generate a weekly calendar with tasks" do
    self.output_buffer = ''
    weekly_calendar(@tasks, :date => Date.parse("12/02/2009 12:00 AM"), :include_24_hours => false) do |w|
      w.week(:business_hours => true, :clickable_hours => false) do |time_slot,truncate| 
        "#{time_slot.name} Test"
      end
    end
    expected = %(<div id=\"week\"><div class=\"days\" id=\"days\"><div class=\"placeholder\" id=\"placeholder\">Week</div><div class=\"day\" id=\"day_0\" style=\"height: 75px;\"><div class=\"day-label\"><b>Wed</b><br />12/02</div></div><div class=\"day\" id=\"day_1\" style=\"height: 75px;\"><div class=\"day-label\"><b>Thu</b><br />12/03</div></div><div class=\"day\" id=\"day_2\" style=\"height: 75px;\"><div class=\"day-label\"><b>Fri</b><br />12/04</div></div><div class=\"day\" id=\"day_3\" style=\"height: 75px;\"><div class=\"day-label\"><b>Sat</b><br />12/05</div></div><div class=\"day\" id=\"day_4\" style=\"height: 75px;\"><div class=\"day-label\"><b>Sun</b><br />12/06</div></div><div class=\"day\" id=\"day_5\" style=\"height: 75px;\"><div class=\"day-label\"><b>Mon</b><br />12/07</div></div><div class=\"day\" id=\"day_6\" style=\"height: 75px;\"><div class=\"day-label\"><b>Tue</b><br />12/08</div></div></div><div class=\"all_day_events\" id=\"all_day_events\"><div class=\"placeholder\" id=\"all-day-placeholder\">All Day</div><div class=\"days_tasks\" id=\"days_tasks_0\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_1\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_2\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_3\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_4\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_5\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_6\" style=\"height: 75px;\"></div></div><div class=\"hours\" id=\"hours\"><div class=\"full_header_row\" id=\"full_header_row\">)<<
            %(<div class=\"header_box\" id=\"header_box_0\"><b>12am</b></div><div class=\"header_box\" id=\"header_box_1\"><b>1am</b></div><div class=\"header_box\" id=\"header_box_2\"><b>2am</b></div><div class=\"header_box\" id=\"header_box_3\"><b>3am</b></div><div class=\"header_box\" id=\"header_box_4\"><b>4am</b></div><div class=\"header_box\" id=\"header_box_5\"><b>5am</b></div><div class=\"header_box\" id=\"header_box_6\"><b>6am</b></div><div class=\"header_box\" id=\"header_box_7\"><b>7am</b></div><div class=\"header_box\" id=\"header_box_8\"><b>8am</b></div><div class=\"header_box\" id=\"header_box_9\"><b>9am</b></div><div class=\"header_box\" id=\"header_box_10\"><b>10am</b></div><div class=\"header_box\" id=\"header_box_11\"><b>11am</b></div><div class=\"header_box\" id=\"header_box_12\"><b>12pm</b></div><div class=\"header_box\" id=\"header_box_13\"><b>1pm</b></div><div class=\"header_box\" id=\"header_box_14\"><b>2pm</b></div><div class=\"header_box\" id=\"header_box_15\"><b>3pm</b></div><div class=\"header_box\" id=\"header_box_16\"><b>4pm</b></div><div class=\"header_box\" id=\"header_box_17\"><b>5pm</b></div><div class=\"header_box\" id=\"header_box_18\"><b>6pm</b></div><div class=\"header_box\" id=\"header_box_19\"><b>7pm</b></div><div class=\"header_box\" id=\"header_box_20\"><b>8pm</b></div><div class=\"header_box\" id=\"header_box_21\"><b>9pm</b></div><div class=\"header_box\" id=\"header_box_22\"><b>10pm</b></div><div class=\"header_box\" id=\"header_box_23\"><b>11pm</b></div></div><div class=\"full_grid\" id=\"full_grid\"><div class=\"full_day_row\" id=\"full_day_row_0\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row_1\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row_2\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row_3\" style=\"height: 75px;\"><div class=\"week_event\" id=\"week_event_339_0\" style=\"top: 0px;left:600.0px;width:288.0px;\"><div style=\"width:1500px;\"></div></div><div class=\"week_event\" id=\"week_event_339_1\" style=\"top: 29px;left:600.0px;width:288.0px;\"><div style=\"width:1500px;\"></div></div></div><div class=\"full_day_row\" id=\"full_day_row_4\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row_5\" style=\"height: 75px;\"></div><div class=\"full_day_row\" id=\"full_day_row_6\" style=\"height: 75px;\"></div></div></div></div>)
               
    assert_dom_equal expected, output_buffer
    assert output_buffer.include?("<div class=\"week_event\" id=\"week_event_339_0\""), "The output should have a dive with an id of week_event_339_0."
  end
  
  should "generate a weekly calendar with a mix of all day and timed tasks" do
    self.output_buffer = ''
    weekly_calendar(@mixed_tasks, :date => Date.parse("12/02/2009 12:00 AM"), :include_24_hours => false) do |w|
      w.week(:business_hours => false, :clickable_hours => false) do |time_slot,truncate| 
        "#{time_slot.name} Test"
      end
    end
    expected = %(<div id=\"week\"><div class=\"days\" id=\"days\"><div class=\"placeholder\" id=\"placeholder\">Week</div><div class=\"day\" id=\"day_0\" style=\"height: 75px;\"><div class=\"day-label\"><b>Wed</b><br />12/02</div></div><div class=\"day\" id=\"day_1\" style=\"height: 75px;\"><div class=\"day-label\"><b>Thu</b><br />12/03</div></div><div class=\"day\" id=\"day_2\" style=\"height: 75px;\"><div class=\"day-label\"><b>Fri</b><br />12/04</div></div><div class=\"day\" id=\"day_3\" style=\"height: 75px;\"><div class=\"day-label\"><b>Sat</b><br />12/05</div></div><div class=\"day\" id=\"day_4\" style=\"height: 75px;\"><div class=\"day-label\"><b>Sun</b><br />12/06</div></div><div class=\"day\" id=\"day_5\" style=\"height: 75px;\"><div class=\"day-label\"><b>Mon</b><br />12/07</div></div><div class=\"day\" id=\"day_6\" style=\"height: 75px;\"><div class=\"day-label\"><b>Tue</b><br />12/08</div></div></div><div class=\"all_day_events\" id=\"all_day_events\"><div class=\"placeholder\" id=\"all-day-placeholder\">All Day</div><div class=\"days_tasks\" id=\"days_tasks_0\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_1\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_2\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_3\" style=\"height: 75px;\"><div class=\"all_day_event\" id=\"all_day_event_339_0\"><div style=\"width:1500px;\"></div></div><div class=\"all_day_event\" id=\"all_day_event_339_1\"><div style=\"width:1500px;\"></div></div></div><div class=\"days_tasks\" id=\"days_tasks_4\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_5\" style=\"height: 75px;\"></div><div class=\"days_tasks\" id=\"days_tasks_6\" style=\"height: 75px;\"></div></div><div class=\"hours\" id=\"hours\"><div class=\"header_row\" id=\"header_row\"><div class=\"header_box\" id=\"header_box_0\"><b>6am</b></div><div class=\"header_box\" id=\"header_box_1\"><b>7am</b></div><div class=\"header_box\" id=\"header_box_2\"><b>8am</b></div><div class=\"header_box\" id=\"header_box_3\"><b>9am</b></div><div class=\"header_box\" id=\"header_box_4\"><b>10am</b></div><div class=\"header_box\" id=\"header_box_5\"><b>11am</b></div><div class=\"header_box\" id=\"header_box_6\"><b>12pm</b></div><div class=\"header_box\" id=\"header_box_7\"><b>1pm</b></div><div class=\"header_box\" id=\"header_box_8\"><b>2pm</b></div><div class=\"header_box\" id=\"header_box_9\"><b>3pm</b></div><div class=\"header_box\" id=\"header_box_10\"><b>4pm</b></div><div class=\"header_box\" id=\"header_box_11\"><b>5pm</b></div><div class=\"header_box\" id=\"header_box_12\"><b>6pm</b></div><div class=\"header_box\" id=\"header_box_13\"><b>7pm</b></div><div class=\"header_box\" id=\"header_box_14\"><b>8pm</b></div></div><div class=\"grid\" id=\"grid\"><div class=\"day_row\" id=\"day_row_0\" style=\"height: 75px;\"></div><div class=\"day_row\" id=\"day_row_1\" style=\"height: 75px;\"></div><div class=\"day_row\" id=\"day_row_2\" style=\"height: 75px;\"></div><div class=\"day_row\" id=\"day_row_3\" style=\"height: 75px;\"><div class=\"week_event\" id=\"week_event_339_0\" style=\"top: 0px;left:150.0px;width:288.0px;\"><div style=\"width:1500px;\"></div></div><div class=\"week_event\" id=\"week_event_339_1\" style=\"top: 29px;left:150.0px;width:288.0px;\"><div style=\"width:1500px;\"></div></div></div><div class=\"day_row\" id=\"day_row_4\" style=\"height: 75px;\"></div><div class=\"day_row\" id=\"day_row_5\" style=\"height: 75px;\"></div><div class=\"day_row\" id=\"day_row_6\" style=\"height: 75px;\"></div></div></div></div>)
    assert_dom_equal expected, output_buffer
    assert output_buffer.include?("<div class=\"all_day_event\" id=\"all_day_event_339_1\">"), "The output should have a dive with an id of all_day_event_339_1."
  end
  
  should "generate a weekly calendar without tasks or a start date" do
    self.output_buffer = ''
    weekly_calendar(@no_tasks, :date => nil, :include_24_hours => false) do |w|
      w.week(:business_hours => true, :clickable_hours => false) do |time_slot,truncate| 
        "Test"
      end
    end
    assert output_buffer.include?(Date.today.strftime("%m/%d"))
  end

end
