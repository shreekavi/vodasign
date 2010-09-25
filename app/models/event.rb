class Event < ActiveRecord::Base

	def self.current_year
		Time.now.strftime("%Y").to_i
	end
	
	def self.current_month
		Time.now.strftime("%m").to_i	
	end
	
	def self.current_day
		Time.now.strftime("%d").to_i	
	end
	
	def self.current_hour
		Time.now.strftime("%H").to_i	
	end
	
	def self.current_minutes
		Time.now.strftime("%M").to_i	
	end
	def self.shift1_start_time
		Time.local(current_year, current_month, current_day, 9, 30, 00)
	end
	
	def self.shift1_end_time
		Time.local(current_year, current_month, current_day, 18, 30, 00)
	end
	
	def self.shift2_start_time
		Time.local(current_year, current_month, current_day, 17, 30, 00)
	end
	
	def self.shift2_end_time
		Time.local(current_year, current_month, current_day+1, 2, 30, 00)
	end	

	def self.shift3_start_time
		Time.local(current_year, current_month, current_day, 1, 30, 00)
	end
	
	def self.shift3_end_time
		Time.local(current_year, current_month, current_day, 10, 30, 00)
	end

	def self.current_shift
		# This can be current time, refactor it later
		#event_time_stamp = Time.local(2010, 9, 24, 2, 29,00)
		event_time_stamp = Time.now
		if event_time_stamp.between?(shift1_start_time, shift1_end_time)
			return "shift1"
		end

		if event_time_stamp.between?(shift2_start_time, shift2_end_time)
			return "shift2"
		end

		if event_time_stamp.between?(shift3_start_time, shift3_end_time)
			return "shift3"
		end

	end
end
