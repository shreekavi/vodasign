class Tweet < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :message
	
	def email
		User.find(self.created_by).email
	end
	
	def self.per_page
	      10
    	end
end
