class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: %i[index show]

  # GET /posts or /posts.json
  def index
    @posts = Post.includes(:user).all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
    authorize @post
  end

  # GET /posts/1/edit
  def edit
    authorize @post 
  end

  # POST /posts or /posts.json
  def create
    # 1. Construir el objeto con los parámetros permitidos
    @post = current_user.posts.build(post_params)
    
    # 2. Sanear el contenido ANTES de autorizar y guardar (ESTO YA ESTÁ CORRECTO)
    @post.title = sanitize_post_content(@post.title)
    @post.content = sanitize_post_content(@post.content)

    authorize @post

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    authorize @post
    
    # 1. Preparar un hash con los parámetros saneados
    sanitized_params = post_params.to_h # Convertir a Hash para poder modificarlo
    
    # Sanear tanto el título como el contenido si están presentes en los parámetros
    sanitized_params[:title] = sanitize_post_content(sanitized_params[:title]) if sanitized_params.key?(:title) # <--- AÑADIR ESTA LÍNEA
    sanitized_params[:content] = sanitize_post_content(sanitized_params[:content]) if sanitized_params.key?(:content)

    respond_to do |format|
      # 2. Usar el hash saneado para la actualización
      if @post.update(sanitized_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    authorize @post
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content)
    end

    def sanitize_post_content(dirty_html)
      return nil if dirty_html.nil?
      # Configuración SECURE_FRAMEWORK definida en config/initializers/sanitize.rb
      Sanitize.fragment(dirty_html, Sanitize::Config::SECURE_FRAMEWORK)
    end
end
