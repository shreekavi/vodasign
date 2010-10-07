class TweetsController < ApplicationController
  # GET /tweets
  # GET /tweets.xml
  layout 'application', :except=>['render_tweet']
  def index
    @tweets = Tweet.paginate :page=>params[:page], :per_page=>10 , :order=>"created_at DESC"
    #@tweets = Tweet.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tweets }
    end
  end

  # GET /tweets/1
  # GET /tweets/1.xml
  def show
    @tweet = Tweet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tweet }
    end
  end

  # GET /tweets/new
  # GET /tweets/new.xml
  def new
    @tweet = Tweet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tweet }
    end
  end

  # GET /tweets/1/edit
  def edit
    @tweet = Tweet.find(params[:id])
  end

  # POST /tweets
  # POST /tweets.xml
  def create
    @tweet = Tweet.new(params[:tweet])
    @tweet.created_by = 1

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to(@tweet, :notice => 'Tweet was successfully created.') }
        format.xml  { render :xml => @tweet, :status => :created, :location => @tweet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tweet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tweets/1
  # PUT /tweets/1.xml
  def update
    @tweet = Tweet.find(params[:id])
    
    respond_to do |format|
      if @tweet.update_attributes(params[:tweet])
        format.html { redirect_to(@tweet, :notice => 'Tweet was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tweet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.xml
  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy

    respond_to do |format|
      format.html { redirect_to(tweets_url) }
      format.xml  { head :ok }
    end
  end
  
  ## Custom Action
  def send_data
     if params[:message].empty?
     	#flash[:notice]= "Message Cannot be empty"
     	render :update do |page|
	    page.replace_html  'notice', "Message cannot be Empty"
	    page.visual_effect :highlight, 'notice'
   
	  end

     else
	@message = Tweet.new(:message=>params[:message])
	@message.created_by = 1
        @message.save
        render :juggernaut do |page|
            page.replace_html 'message_data', "#{h params[:message]}</p>"
    	end
	render :nothing => true
     end
  end

  ##Action to render the tweets on Signage
  def render_tweet
  	@ip = VODASIGN_CONFIG['juggernaut_ip']
  end

end
