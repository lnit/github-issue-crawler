class Timeline
  attr_reader :events

  Report = Struct.new(
    :accept_at,
    :accept_at_str,
    :done_at,
    :done_at_str,
    :diff_total,
    :diff_time,
    :diff_str,
  )

  def initialize(timeline_response)
    @events = timeline_response
  end

  def report
    @report ||= Report.new(
      accept_event&.created_at&.localtime,
      accept_event&.created_at&.localtime&.strftime("%F %T"),
      done_event&.created_at&.localtime,
      done_event&.created_at&.localtime&.strftime("%F %T"),
      diff_total,
      diff_time,
      diff_str,
    )
  end

  def move_column_events
    return @move_column_events if defined?(@move_column_events)

    events.select do |e|
      e.event == "moved_columns_in_project"
    end
  end

  def accept_event
    return @accept_event if defined?(@accept_event)

    @accept_event = move_column_events.select do |e|
      e.project_card.previous_column_name =~ /To.?do/
    end.first
  end

  def done_event
    return @done_event if defined?(@done_event)

    @done_event = move_column_events.select do |e|
      e.project_card.column_name =~ /Done/
    end.last
  end

  def diff_total
    return @diff_total if defined?(@diff_total)

    if accept_event && done_event
      @diff_total = done_event.created_at - accept_event.created_at
    else
      @diff_total = nil
    end
  end

  def diff_time
    @diff_Time ||= diff_total && Time.at(diff_total).utc
  end

  def diff_str
    return nil unless diff_total
    return @diff_str if defined?(@diff_str)

    day = "#{diff_total.to_i / (3600 * 24)}日"
    hm = diff_time.strftime("%H時間%M分")

    @diff_str = day + hm
  end
end
