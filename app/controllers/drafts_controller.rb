class DraftsController < ApplicationController
  before_action :require_login, only: [:create, :update, :destroy]

  def printXml
    respond_to do |format|
      format.xml 
    end
  end

  def index
    if user_signed_in?
  	 @drafts = current_user.drafts.all 
    else
      @drafts = Draft.all
    end
  	if @drafts.empty?
      if user_signed_in?

        puts 'all drafts empty: '
        @draft = current_user.drafts.build
      else
    		@draft = Draft.new
      end
  	else
  		@draft = @drafts.last
  	end
  end

  def show
  	@draft = Draft.find(params[:id])

  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

  def create
  	@draft = current_user.drafts.build(draft_params)
    @draft.save
  	@drafts = current_user.drafts.all
  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

  def update
  	@draft = current_user.drafts.build(draft_params)
    @draft.save
  	@drafts = current_user.drafts.all
  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

  def destroy
  	@draft = Draft.find(params[:id])
    @destroyId = @draft.id
    @draft.destroy
    if user_signed_in?
      @drafts = current_user.drafts.all
    else
      @drafts = Draft.all
    end
    if @drafts.empty?
      @replaceDraft = current_user.drafts.build
    else
      @replaceDraft = current_user.drafts.last
    end
    
  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

  def compare # current and other are IDs of drafts
    if current_user.drafts.exists?(params[:current]) and current_user.drafts.exists?(params[:other])
      @current = current_user.drafts.find(params[:current]).content
      @other = current_user.drafts.find(params[:other]).content
      @diffTemp = Differ.diff_by_word(@other, @current)
      @diff = @diffTemp.format_as(:html)
      puts @diff

      respond_to do |format|
        format.html
        format.js
      end
    else
      puts "Tried to call Drafts#compare with invalid draft IDs: " + 
        params[:current] + "and/or" + params[:other]
    end
  end


  private

  def draft_params
  	params.require(:draft).permit(:content)
  end

  def require_login
    unless user_signed_in?
      flash[:error] = "You must be logged in to access this section"
      flash.keep(:notice)
      render js: "window.location = '"+new_user_session_path+"'"
    end
  end
end
