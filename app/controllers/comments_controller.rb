class CommentsController < ApplicationController
  before_action :set_comment, only: [:update, :destroy,:show]
  before_action :set_article
  before_action :authenticate_user!
  # GET /comments
  # GET /comments.json

  # POST /comments
  # POST /comments.json
  def show
  end
  def create
#desde el usuario logueado accedo a has_many :coments y le paso los parametros
#que serian el id del usario logueado, el articulo que esta por url y el cuerpo
#del comentario que se envia por form
    @comment = current_user.comments.new(comment_params)
    @comment.article = @article
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.article, notice: 'Se creo correctamente el comentario.' }
        format.json { render :show, status: :created, location: @comment.article }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def edit
  end
  def update
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    if @comment.save
        redirect_to article_path(@article)
    else
      render :edit
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to article_path(@article), notice: 'El comentario fue eliminado con exito.' }
      format.json { head :no_content }
    end
  end

  private
    def set_article
      @article = Article.find(params[:article_id]) #obtengo el id del articulo al cual pertenece el comment
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      #solicito la tabla comment y le asigno el hash enviado por post del form
      #donde cada parametro envio por el hash coinsiden con los de la tabla
      params.require(:comment).permit(:user_id, :article_id, :body)
    end
    def update_params
      params.require(:comment).permit(:body)
    end
end
