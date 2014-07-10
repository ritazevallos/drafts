class DraftsController < ApplicationController
  def printXml
    respond_to do |format|
      format.xml 
    end
  end

  def index
  	@drafts = Draft.all
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
  	@draft = Draft.create(draft_params)
  	@drafts = Draft.all
  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

  def update
  	@draft = Draft.create(draft_params)
  	@drafts = Draft.all
  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

  def destroy
  	@draft = Draft.find(params[:id])
  	@drafts = Draft.all
    @destroyId = @draft.id
    @draft.destroy
    @replaceDraft = Draft.last

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
end
