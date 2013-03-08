class Comment < ActiveRecord::Base
  DEFAULT_LIMIT = 15

  attr_accessor         :openid_error
  attr_accessor         :openid_valid

  belongs_to            :post

  before_save           :apply_filter
  after_save            :denormalize
  after_destroy         :denormalize

  after_create :send_notification

  validates :post, presence: true
  validates :author, presence: {message: 'Please provide your name'}
  validates :body, presence: {message: 'Please comment'}
  validates :author_url, presence: {message: 'Please provide your OpenID identity URL'}

  validate :open_id_error_should_be_blank

  attr_accessible :author, :body, :author_url

  def open_id_error_should_be_blank
    errors.add(:author_url, openid_error) unless openid_error.blank?
  end

  def apply_filter
    self.body_html = Lesstile.format_as_xhtml(self.body, :code_formatter => Lesstile::CodeRayFormatter)
  end

  def blank_openid_fields
    self.author_url = ""
    self.author_email = ""
  end

  def requires_openid_authentication?
    # return false unless author

    # !!(author =~ %r{^https?://} || author.index('.'))
    true
  end

  def trusted_user?
    false
  end

  def user_logged_in?
    false
  end

  def approved?
    true
  end

  def denormalize
    self.post.denormalize_comments_count!
  end

  def destroy_with_undo
    undo_item = nil
    transaction do
      self.destroy
      undo_item = DeleteCommentUndo.create_undo(self)
    end
    undo_item
  end

  # Delegates
  def post_title
    post.title
  end

  def send_notification
    CommentMailer.notification(self).deliver
  end

  class << self
    def new_with_filter(params)
      comment = Comment.new(params)
      comment.created_at = Time.now
      comment.apply_filter
      comment
    end

    def build_for_preview(params)
      comment = Comment.new_with_filter(params)
      if comment.requires_openid_authentication?
        comment.author_url = comment.author
        comment.author     = "Your OpenID Name"
      end
      comment
    end

    def find_recent(options = {})
      find(:all, {
        :limit => DEFAULT_LIMIT,
        :order => 'created_at DESC'
      }.merge(options))
    end
  end
end
