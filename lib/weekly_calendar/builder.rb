class WeeklyCalendar::Builder
  include ::ActionView::Helpers::TagHelper

  def initialize(objects, template, options, start_date, end_date)
    raise ArgumentError, "WeeklyBuilder expects an Array but found a #{objects.inspect}" unless objects.is_a? Array
    @objects, @template, @options, @start_date, @end_date = objects, template, options, start_date, end_date
    @event_height = 29
    @default_day_height = 75
  end
  
  def days
    concat(tag("div", {:id => "days", :class => "days"}, true))
      concat(content_tag("div", "Weekly View", :id => "placeholder", :class => "placeholder"))
      for day in @start_date..@end_date 
        days_events = events_in_day(@objects, day)
        height = days_events.length * @event_height <= @default_day_height ? @default_day_height : days_events.length * @event_height
        concat(tag("div", {:id => "day", :class => "day", :style => "height: #{height}px;"}, true))
          concat(tag("div", {:class => "day-label"}, true))
            concat(content_tag("b", day.strftime('%A')))
            concat(tag("br"))
            concat(day.strftime('%B %d'))
          concat("</div>")
        concat("</div>")
      end
    concat("</div>")      
  end
  
  def week(options = {})    
    if options[:business_hours] == "true" or options[:business_hours].blank?
      hours = ["6am","7am","8am","9am","10am","11am","12pm","1pm","2pm","3pm","4pm","5pm","6pm","7pm","8pm"]
      header_row = "header_row"
      day_row = "day_row"
      grid = "grid"
      @start_hour = 6
      @end_hour = 20
    else
      hours = ["12am","1am","2am","3am","4am","5am","6am","7am","8am","9am","10am","11am","12pm","1pm","2pm","3pm","4pm","5pm","6pm","7pm","8pm","9pm","10pm","11pm"]
      header_row = "full_header_row"
      day_row = "full_day_row"
      grid = "full_grid"
      @start_hour = 1
      @end_hour = 24
    end
    days
    concat(tag("div", {:id => "hours", :class => "hours"}, true))
      concat(tag("div", {:id => header_row, :class => header_row}, true))
        for hour in hours
          header_box = "<b>#{hour}</b>"
          concat(content_tag("div", header_box, :id => "header_box", :class => "header_box"))
        end
      concat("</div>")
      concat(tag("div", {:id => grid, :class => grid}, true))
        for day in @start_date..@end_date 
          days_events = events_in_day(@objects, day)
          height = days_events.length * @event_height <= @default_day_height ? @default_day_height : days_events.length * @event_height
          concat(tag("div", {:id => day_row, :class => day_row, :style => "height: #{height}px;"}, true))
          i = 0
          for event in days_events
            div_options = {
              :id => "week_event",
              :class => "week_event",
              :style =>"top: #{i * @event_height}px;left:#{left(event.starts_at,options[:business_hours])}px;width:#{width(event.starts_at,event.ends_at)}px;"
            }
            if options[:clickable_hours] == true
              div_options.merge!({:onclick => "location.href='/tasks/#{event.task.id}';"})
            end
            concat(tag("div", div_options, true))
              truncate = truncate_width(width(event.starts_at,event.ends_at))
              yield(event,truncate)
            concat("</div>")
            i = i+1
          end
          concat("</div>")
        end
      concat("</div>")
    concat("</div>")
  end
  
  private
  
    def concat(tag)
      @template.concat(tag)
    end

    def left(starts_at,business_hours)
      if business_hours == "true" or business_hours.blank?
        minutes = starts_at.strftime('%M').to_f * 1.25
        hour = starts_at.strftime('%H').to_f - 6
      else
        minutes = starts_at.strftime('%M').to_f * 1.25
        hour = starts_at.strftime('%H').to_f
      end
      left = (hour * 75) + minutes
    end

    def width(starts_at,ends_at)
      #example 3:30 - 5:30
      start_hours = starts_at.strftime('%H').to_i * 60 # 3 * 60 = 180
      start_minutes = starts_at.strftime('%M').to_i + start_hours # 30 + 180 = 210
      end_hours = ends_at.strftime('%H').to_i * 60 # 5 * 60 = 300
      end_minutes = ends_at.strftime('%M').to_i + end_hours # 30 + 300 = 330
      difference =  (end_minutes.to_i - start_minutes.to_i) * 1.25 # (330 - 180) = 150 * 1.25 = 187.5
    
      unless difference < 60
        width = difference - 12
      else
        width = 63 #default width (75px minus padding+border)
      end
    end
    
    def events_in_day(events, day)
      days_events = []
      for event in events
        if event.starts_at.strftime('%j').to_s == day.strftime('%j').to_s 
         if event.starts_at.strftime('%H').to_i >= @start_hour and event.ends_at.strftime('%H').to_i <= @end_hour
           days_events << event
          end
        end
      end
      return days_events
    end
  
    def truncate_width(width)
      hours = width / 63
      truncate_width = 20 * hours
    end
    
end