class ArticlesController < ApplicationController
  before_action :set_article, except: [:index,:new,:create]
  before_action :authenticate_user!, except: [:show,:index] #llama a un callback propio de devise
  # before_action :authenticate_user!, only: [:create,:new] # otra forma de hacerlo
  # before_action :validate_user, except: [:show, :index] # hacerlo manuelamente y luego crear el metodos
  def index
    @articles = Article.all  # las variables con @ son accesibles desd el controlador y la vista
  end
  #Get /article/:id
  def show
    @article.update_visits_count
    @comment = Comment.new
    # Article.where.not('id = ?',params[:id])
  end
  #GET /articles/new REDIRECCIONO A ESTA RUTA Y ASIGNO LOS CAMPOS DEL POST A LOS DE LA TABLA PARA LUEGO PROCEDER CON CREATE
  def new
    @article = Article.new
  end
# REDIRECCIONO A EDIT A TRAVES DEL ID Y ASIGNO LOS NUEVOS CAMPOS DEL POST A LOS DEL LA TABLA PARA LUEGO PROCEDER CON UPDATE
  def edit
  end
  #POST /articles
# RECIBO LOS CAMPOS ENVIADOS POR URL DEL NEW E INSERTO UNA NUEVA COLUMNA EN LA TABLA
  def create
    @article = current_user.articles.new(article_params) # se llama al metodo article_params
      if @article.save
        redirect_to @article  #redirecciona al articulo que se acaba de crear
      else                    #esto pasa el id del nuevo articulo por parametro que el metodo show capturara y mostrara
        render :new
      end
  end
# DESTRUYO LA COLUMNA DE LA BASE DE LA TABLA
  def destroy
    @article.destroy
    redirect_to articles_path
  end
# RECIVO LOS CAMPOS POR PATH MANDADOS POR EDIT Y ACTUALIZO EL CAMPO EN LA BASE DE DATOS
  def update
    if @article.update(article_params)
      redirect_to @article
    else
      render_to :edit
    end
  end

# Funcion para validar que solo se permita que se envie por parametro el titulo y el body (por seguridad)
  private
  def set_article
    @article = Article.find(params[:id])
  end
  # def validate_user
  #   redirect_to new_user_session_path, notice: 'Debes iniciar Sesion'
  # end
  def article_params
    params.require(:article).permit(:title,:body) #obtengo el hash enviado por url (:title,:body)
  end                                             #del form y se le asigno la tabla
end

# cuando se envia por el path un parametro que ya existe en el modelo
# entonces automaticamente entra en el metodo update,
# sino existe entra en el metodo create
#
# al redireccionar a @article se envia por el path los parametros nuevos creados
# al crearse automaticamente se le asigna un id
# entonces vuelve a ocurrir el mismo siclo si existe ese id entra en update
# sino en create
