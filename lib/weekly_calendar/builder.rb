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
      (@start_date..@end_date).each_with_index do |day, index| 
        days_events = events_in_day(day)
        height = row_height(day)
        concat(tag("div", {:id => "day_#{index}", :class => "day", :style => "height: #{height}px;"}, true))
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
      @start_hour = 0
      @end_hour = 23
    end
    days
    
    # Add all day events to the left of the hourly grid.
    concat(tag("div", {:id => "all_day_events", :class => "all_day_events"}, true))
      concat(content_tag("div", "All Day", :id => "all-day-placeholder", :class => "placeholder"))
      (@start_date..@end_date).each_with_index do |day, index| 
        
        all_day_events = all_day_events_in_day(day)
        height = row_height(day)
        concat(tag("div", {:id => "days_tasks_#{index}", :class => "days_tasks", :style => "height: #{height}px;"}, true))
            
            all_day_events.each_with_index do |event, i|
              div_options = {
                :id => "all_day_event_#{day.strftime('%j').to_s}_#{i}",
                :class => "all_day_event",
              }
              concat(tag("div", div_options, true))
                all_day = true
                truncate = truncate_width(width(event.starts_at,event.ends_at))
                yield(event, truncate, all_day)
              concat("</div>")
            end
            
        concat("</div>")
      end
    concat("</div>")
    
    concat(tag("div", {:id => "hours", :class => "hours"}, true))
      concat(tag("div", {:id => header_row, :class => header_row}, true))
        hours.each_with_index do |hour, index|
          header_box = "<b>#{hour}</b>"
          concat(content_tag("div", header_box, :id => "header_box_#{index}", :class => "header_box"))
        end
      concat("</div>")
      concat(tag("div", {:id => grid, :class => grid}, true))
        (@start_date..@end_date).each_with_index do |day, index|  
          days_events = events_in_day(day)
          height = row_height(day)
          concat(tag("div", {:id => "#{day_row}_#{index}", :class => day_row, :style => "height: #{height}px;"}, true))
          days_events.each_with_index do |event, i|
            div_options = {
              :id => "week_event_#{day.strftime('%j').to_s}_#{i}",
              :class => "week_event",
              :style =>"top: #{i * @event_height}px;left:#{left(event.starts_at,options[:business_hours])}px;width:#{width(event.starts_at,event.ends_at)}px;"
            }
            if options[:clickable_hours] == true
              div_options.merge!({:onclick => "location.href='/tasks/#{event.task.id}';"})
            end
            concat(tag("div", div_options, true))
              all_day = false
              truncate = truncate_width(width(event.starts_at,event.ends_at))
              yield(event, truncate, all_day)
            concat("</div>")
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
    
    # Compare the start and end time for each event and return
    # only those that are on the requested day that start and end within the start and end hours.
    def events_in_day(day)
      days_events = []
      for event in @objects
        if event.starts_at.strftime('%j').to_s == day.strftime('%j').to_s 
         if event.starts_at.strftime('%H').to_i >= @start_hour and event.ends_at.strftime('%H').to_i <= @end_hour and event.starts_at.strftime('%H').to_i != 0
           days_events << event
          end
        end
      end
      return days_events
    end
    
    # Compare the start and end time for each event and return
    # only those that are on the requested day that start at hour 0 and end at hour 23.
    def all_day_events_in_day(day)
      all_day_events = []
      for event in @objects
        if event.starts_at.strftime('%j').to_s == day.strftime('%j').to_s 
         if (event.starts_at.strftime('%H').to_i == 0 and event.ends_at.strftime('%H').to_i == 23)
           all_day_events << event
          end
        end
      end
      return all_day_events
    end
    
    # Compare the height of the default row, all day events and regular events and return the 
    # highest value. Used to determin the height of the row.
    def row_height(day)
      days_events = events_in_day(day)
      all_day_events = all_day_events_in_day(day)
      all_day_events_height = all_day_events.length * @event_height <= @default_day_height ? @default_day_height : all_day_events.length * @event_height
      height = days_events.length * @event_height <= @default_day_height ? @default_day_height : days_events.length * @event_height
      height = all_day_events_height if all_day_events_height > height
      return height
    end
  
    def truncate_width(width)
      hours = width / 63
      truncate_width = 20 * hours
    end
    
end