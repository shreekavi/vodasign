class BirthdaysController < ApplicationController
  def index
     @birthdays = Birthday.find(:all, :conditions => ["DAY(date_of_birth) = ? AND MONTH(date_of_birth) = ? ", Time.now.day, Time.now.month])
  end

  def new
  end

  def show
  end

  def edit
  end

  def create
  end

  def update
  end

 def import
 flash[:success] = []
 flash[:error] = []
   file = params[:document][:file]## Browse fil
   total_birthdays_saved,total_birthdays_errors,rows_to_skip,row_count = 0,0,1,0   
   FasterCSV.parse(file) do |row|           
     name,department,designation,email,date_of_birth = row
     if row_count > rows_to_skip - 1# To skip header
     	birthday = Birthday.new(:name=>name.strip,:department=>department.strip,:designation=>designation.strip,
                               :email=>email.strip,:date_of_birth=>date_of_birth.strip)
       	if birthday.save
        	total_birthdays_saved +=1         
	    else
    	     #Display Validations
    	     total_birthdays_errors += 1
    	     error = "<br/>Birthday--Errors at line number <b>#{row_count+1}</b>"     
    	     birthday.errors.each_full { |msg| error << "<br/> -- #{msg}" }     
    	     flash[:error] << error
    	end
     end
      row_count += 1  
  end
  flash[:success] << "Total Birthdays Saved - #{total_birthdays_saved}"
  flash[:success] << "Total Birthday Errors - #{total_birthdays_errors}"
  redirect_to :action=>'index'
end
end
