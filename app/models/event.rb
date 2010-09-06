class Event < ActiveRecord::Base
	  named_scope :today, 
	  	      :conditions => {:event_date=>"#{Date.today.strftime("%Y-%m-%d")}"}
	  #named_scope :current_meeting
	  named_scope :past_meetings,
	  	      :order => "event_date ASC", 
	  	      :conditions => ["event_date < :eventdate",{:eventdate => Date.today}]
	  named_scope :future_meetings,
	              :order => "event_date DESC", 
	              :conditions => ["event_date > :eventdate",{:eventdate => Date.today}]
end
