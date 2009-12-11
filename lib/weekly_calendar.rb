# WeeklyCalendar by Dan McGrady 2009
module WeeklyCalendar
  
  def weekly_calendar(objects, *args)
    #view helper to build the weekly calendar
    options = args.last.is_a?(Hash) ? args.pop : {}
    date = options[:date] || Time.now
    start_date = Date.new(date.year, date.month, date.day)
    end_date = Date.new(date.year, date.month, date.day) + 6
    
    concat(tag("div", {:id => "week"}, true))
      
      yield WeeklyCalendar::Builder.new(objects || [], self, options, start_date, end_date)
      
    concat("</div>")
    
    if options[:include_24_hours] == true
      concat("<b><a href='?business_hours=true&start_date=#{start_date}'>Business Hours</a> | <a href='?business_hours=false&start_date=#{start_date}'>24-Hours</a></b>")
    end
  end
  
  def weekly_links(options)
    #view helper to insert the next and previous week links
    date = options[:date] || Time.now
    start_date = Date.new(date.year, date.month, date.day) 
    end_date = Date.new(date.year, date.month, date.day) + 6
    concat("<a href='?start_date=#{start_date - 7}#{options[:query_strings]}'>« Previous Week</a> ")
    concat("#{start_date.strftime("%B %d -")} #{end_date.strftime("%B %d")} #{start_date.year}")
    concat(" <a href='?start_date=#{start_date + 7}#{options[:query_strings]}'>Next Week »</a>")
  end
  
  # Convenience method to sort a list of tasks into a hash with an array of tasks for each day in the hash.
  # Result {{day1 => [task, task, task]}, {day2 => [task, task, task]}}
  def tasks_listed_by_days(day_range, tasks)
    tasks_by_days = Hash.new
    day_range.each do |day| 
      days_tasks = []
      tasks.each do |task|
        if task.starts_at.strftime('%j').to_s == day.strftime('%j').to_s 
          days_tasks << task
        end
      end
      tasks = tasks - days_tasks
      day_hash = { day => days_tasks }
      tasks_by_days = tasks_by_days.merge(day_hash)
    end
    return tasks_by_days
  end

end