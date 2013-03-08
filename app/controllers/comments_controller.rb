class CommentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  before_filter :verify_authenticity_token_unless_openid, :only => :create

  include UrlHelper
  OPEN_ID_ERRORS = {
    :missing  => "Sorry, the OpenID server couldn't be found",
    :canceled => "OpenID verification was canceled",
    :failed   => "Sorry, the OpenID verification failed" }

  before_filter :find_post, :except => [:new]

  def index
    redirect_to(post_path(@post))
  end

  def new
    @comment = Comment.build_for_preview(params[:comment])

    respond_to do |format|
      format.js do
        render :partial => 'comment', :locals => {:comment => @comment}
      end
    end
  end

  # TODO: Spec OpenID with cucumber and rack-my-id
  def create
    return redirect_to post_path(@post) # disable comments

    @comment = Comment.new((session[:pending_comment] || params[:comment] || {}))
    @comment.post = @post
    @comment.author_email = @comment.author

    session[:pending_comment] = nil

    unless @comment.valid?
      return render :template => 'posts/show'
    end

    session[:pending_comment] = params[:comment]
    authenticate_with_open_id(@comment.author_url) do |result, identity_url|
      if result.successful?
        @comment.post = @post
        @comment.openid_error = ""

        session[:pending_comment] = nil
      else
        @comment.openid_error = "Invalid OpenID URL"
      end
    end

    # #authenticate_with_open_id may have already provided a response
    unless response.headers[Rack::OpenID::AUTHENTICATE_HEADER]
      if @comment.save
        redirect_to post_path(@post)
      else
        render :template => 'posts/show'
      end
    end
  end

  protected

  def find_post
    @post = Post.find_by_permalink(*[:year, :month, :day, :slug].map {|x|
      params[x]
    })
  end

  def verify_authenticity_token_unless_openid
    verify_authenticity_token unless using_open_id?
  end
end
