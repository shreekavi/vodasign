class EventsController < ApplicationController
  
  layout 'application', :except=>['signage']
  def index
  	@events = Event.find(:all)
  end

  def signage
    	@events = Event.find(:all)
  end

  def current_meeting
  ## A general purpose action to get the details of Current Event
  ## Get the current time and Date.
  ## Find a record that matches current Date and time
  ## Mark it as meeting started
  ## Render the current meeting on View
	@events = Event.find(:all, :conditions=>["event_date = :eventdate",{:eventdate => Date.today}])
  	render :partial => 'current_meeting'
  end
  
  def past_meetings
  ## A general purpose action to get all the past meetings sorted by Date ( Show top 5)
  ## Get the current time and Date.
  ## Find all the records that are marked as completed / closed
  ## Sort the records in descending order or Date and time
  ## Pick Top 5 and render them on the view
  	@events = Event.past_meetings
 	render :partial => 'past_meetings'
  end
  
  def future_meetings
  ## A general purpose action to get all the future meeting sorted by Date and time ( Show top 5)
  ## Get current Date and time
  ## Find all the records that are not marked as completed
  ## Sort the records in ascending order of Date and Time
  	@events = Event.future_meetings
  	render :partial => 'future_meetings'
  end
  
  def rest_of_today_meetings
  ## A general purpose action to get rest of the meetings in the day looking at the current time stamp
  ## Get Current Date and time
  ## Find all the records that belong to current day
  ## Pick all the records and render them in view in descending order
      	render :partial => 'rest_of_today'
  end
  

end
