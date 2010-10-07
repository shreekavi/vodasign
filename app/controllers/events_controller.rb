require 'nokogiri'

class EventsController < ApplicationController
  
  layout 'application', :except=>['signage']
  def index

	

  end

  def signage
		#Read the request for a meeting room from URL
	
		@room_name = params[:id].upcase

	  	@shift1=["9:00","9:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30"]

		@shift2=["17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30","00:00","00:30","1:00","1:30","2:00","2:30"]

		@shift3=["1:30","2:00","2:30","3:00","3:30","4:00","4:30","5:00","5:30","6:00","6:30","7:00","7:30","8:00","8:30","9:00","9:30","10:00","10:30"]

		#Get the Current Shift based on server timestamp
	  	@current_shift = Event.current_shift
	  	
	  	#Get the Shift Time
	  	@current_time = Time.now.strftime("%H:%M")

		mail = params[:id].to_s + '@' + VODASIGN_CONFIG['exchange_domain_name'].to_s

		today = Time.now.strftime("%Y-%m-%d")
		#today = "2010-09-28"
		start_time = today +"T00:00:00"
		end_time = today + "T23:59:59"

		#This XML document can go into a private method
	
		events = search_events(mail, start_time, end_time)

		#################
		@start_times = []
		@end_times = []
		@subjects = []
		events.each do |k|
			@start_times << k["StartTime"]
			@end_times << k["EndTime"]
			@subjects << k["Subject"]
		end 
	end
	
		

  
  private
  
  def search_events(mailbox, starttime, endtime)
  
  	
doc = Nokogiri::XML <<-EOXML1
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xmlns:xsd="http://www.w3.org/2001/XMLSchema"
               xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:t="http://schemas.microsoft.com/exchange/services/2006/types">
  <soap:Body>
    <GetUserAvailabilityRequest xmlns="http://schemas.microsoft.com/exchange/services/2006/messages"
                xmlns:t="http://schemas.microsoft.com/exchange/services/2006/types">
      <t:TimeZone xmlns="http://schemas.microsoft.com/exchange/services/2006/types">
        <Bias>-330</Bias>
        <StandardTime>
          <Bias>0</Bias>
          <Time>00:00:00</Time>
          <DayOrder>5</DayOrder>
          <Month>10</Month>
          <DayOfWeek>Sunday</DayOfWeek>
        </StandardTime>
        <DaylightTime>
          <Bias>0</Bias>
          <Time>00:00:00</Time>
          <DayOrder>1</DayOrder>
          <Month>4</Month>
          <DayOfWeek>Sunday</DayOfWeek>
        </DaylightTime>
      </t:TimeZone>
      <MailboxDataArray>
        <t:MailboxData>
          <t:Email>
            <t:Address>#{mailbox}</t:Address>
          </t:Email>
          <t:AttendeeType>Required</t:AttendeeType>
          <t:ExcludeConflicts>true</t:ExcludeConflicts>
        </t:MailboxData>
      </MailboxDataArray>
      <t:FreeBusyViewOptions>
        <t:TimeWindow>
          <t:StartTime>#{starttime}</t:StartTime>
          <t:EndTime>#{endtime}</t:EndTime>
        </t:TimeWindow>
        <t:MergedFreeBusyIntervalInMinutes>30</t:MergedFreeBusyIntervalInMinutes>
        <t:RequestedView>Detailed</t:RequestedView>
      </t:FreeBusyViewOptions>
    </GetUserAvailabilityRequest>
  </soap:Body>
</soap:Envelope>

EOXML1

		puts doc
		wsdl = `curl -v -u '#{params[:id]}':'#{VODASIGN_CONFIG['mailbox_password']}' -L "https://#{VODASIGN_CONFIG['ews_end_point']}" -d '#{doc.to_xml}' -H "Content-Type:text/xml"`
		response_xml = Nokogiri::XML(wsdl)
		puts response_xml


		aoh = []
		response_xml.remove_namespaces!

		 response_xml.xpath("//CalendarEventArray").children.each do |d|
		 	puts "Child"
	  		h1 = Hash.new
	   		d.children.each do |f|
				if f.name =="StartTime"
					h1["StartDay"] = f.text[0..9]
					if f.text[11] == 48 # ASCII for 0
						h1["StartTime"] = f.text[12..15]
					else
						h1["StartTime"] = f.text[11..15]
					end
				elsif f.name =="EndTime"
					h1["EndDay"] = f.text[0..9]
					if f.text[11] == 48 # ASCII for 0
						h1["EndTime"] = f.text[12..15]
					else
						h1["EndTime"] = f.text[11..15]
					end
				else
	  				h1[f.name] = f.text
				end	  	
				
				##This block is for getting calendar Subject Details
				if f.name=="CalendarEventDetails"
				   f.children.each do |ce|
				   	if ce.name=="Subject"
				   		h1["Subject"] = ce.text
				   	end
				   end
				end
				##

	  		end
	  	
	  		aoh << h1
	  end
	return aoh
  end

end
