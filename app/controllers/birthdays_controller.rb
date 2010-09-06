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

end
