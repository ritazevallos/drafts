class DraftsController < ApplicationController
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
    @draft.destroy
  	respond_to do |format|
  		format.html
  		format.js
  	end
  end

  def compare # current and other are IDs of drafts
    @current = Draft.find(params[:current]).content
    @other = Draft.find(params[:other]).content
    @diff = Differ.diff_by_char(@current, @other)
    @diff.format_as(:html)
    puts @diff.format_as(:html)
    if request.xhr?
      render json: {diff: @diff.format_as(:html)}
    end
  end


  private

  def draft_params
  	params.require(:draft).permit(:content)
  end
end
