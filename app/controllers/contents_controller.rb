class ContentsController < ApplicationController
  before_action :set_content, only: [:show, :update, :destroy]

  respond_to :json

  # GET /contents
  # GET /contents.json
  def index
    @contents = Content.all
    render json: @contents
  end

  # GET /contents/1
  # GET /contents/1.json
  def show
    render json: @content
  end

  def create
    if !params[:content][:assets_attributes] || (params[:content][:assets_attributes].all? &:blank?)
      render json: { errors: "Err! You didn't select any file" }, status: 422 and return
    end
    
    pages = params[:content][:assets_attributes].size
    assets =params["content"].delete("assets_attributes")      
    
    content = Content.new(content_params)
    content.pages = pages    
 
    if content.save
      render json: content, status: 201
      CreateAsset.perform_async(content.id.to_s,assets)
    else
      render json: { errors: content.errors }, status: 422
    end
  end

  # PATCH/PUT /contents/1
  # PATCH/PUT /contents/1.json
  def update
    @content = Content.find(params[:id])

    if @content.update(content_params)
      head :no_content
    else
      render json: @content.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contents/1
  # DELETE /contents/1.json
  def destroy
    @content.destroy

    head :no_content
  end

  private

    def set_content
      @content = Content.find(params[:id])
    end

    def content_params
      params.require(:content).permit(:title, :description, assets_attributes: [ :asset, :asset_tmp ])
    end

end
