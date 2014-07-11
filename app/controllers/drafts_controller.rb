class DraftsController < ApplicationController
  before_action :require_login, only: [:create, :update, :destroy]

  def printXml
    respond_to do |format|
      format.xml 
    end
  end

  def index
  	@drafts = current_user.drafts
  	if @drafts.empty?
  		@draft = Draft.new
  	else
  		@draft = Draft.last
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
  	@drafts = current_user.drafts
  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

  def update
  	@draft = current_user.drafts.build(draft_params)
    @draft.save
  	@drafts = current_user.drafts
  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

  def destroy
  	@draft = Draft.find(params[:id])
  	@drafts = current_user.drafts
    @destroyId = @draft.id
    @draft.destroy
    if current_user.drafts.empty?
      @replaceDraft = current_user.drafts.build
      @draft.save
    else
      @replaceDraft = Draft.last
    end
    
  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

  def compare # current and other are IDs of drafts
    if Draft.exists?(params[:current]) and Draft.exists?(params[:other])
      puts "in if"
      @current = Draft.find(params[:current]).content
      @other = Draft.find(params[:other]).content
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
