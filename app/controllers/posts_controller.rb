class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy like dislike]
  before_action :authenticate_user!, except: [:index,:show]
  before_action :is_admin!, except: [:index,:show, :like, :dislike]
  before_action :authenticate_user!, only: [:like, :dislike]
  # GET /posts or /posts.json
  def index
    @posts = Post.all.order("created_at DESC").paginate(page: params[:page])
  end

  # GET /posts/1 or /posts/1.json
  def show
    views = @post.views.to_i + 1

    @post.update(views: views)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.url.present?
      @post.url_id = @post.get_id_video(@post.url)
      title, content = @post.get_details(@post.url_id)
      @post.title = title
      @post.content = content
    end

    respond_to do |format|
      if @post.save
        format.html { redirect_to root_path, notice: "Movie was successfully shared." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def dislike
    if current_user.voted_for? @post
      @post.undisliked_by current_user
    else
      @post.disliked_by current_user
    end
    redirect_to root_path
  end

  def like
    if current_user.voted_for? @post
      @post.unliked_by current_user
    else
      @post.liked_by current_user
    end
    redirect_to root_path
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
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
      params.require(:post).permit(:url)
    end
end
