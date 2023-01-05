# frozen_string_literal: true

module MeetingsHelper
  def meeting_time(meeting)
    start_clock = l(meeting.start_time, format: :time_of_day)
    end_clock = l(meeting.end_time, format: :time_of_day)

    if meeting.start_time.to_date == meeting.end_time.to_date
      date = l(meeting.start_time.to_date, format: :decidim_short)

      if start_clock == end_clock
        "#{date}&nbsp;klo&nbsp;#{start_clock}".html_safe
      else
        "#{date}&nbsp;klo&nbsp;#{start_clock}-#{end_clock}".html_safe
      end
    else
      start_date = l(meeting.start_time.to_date, format: :decidim_short)
      end_date = l(meeting.end_time.to_date, format: :decidim_short)

      "#{start_date}&nbsp;#{start_clock}&nbsp;-&nbsp;#{end_date}&nbsp;#{end_clock}".html_safe
    end
  end
end
