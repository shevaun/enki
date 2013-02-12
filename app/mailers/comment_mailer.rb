class CommentMailer < ActionMailer::Base
  default from: "#{Enki::Config.default[:author][:name]} <#{Enki::Config.default[:author][:email]}>"

  def notification(comment)
    @post = comment.post
    @comment = comment
    mail(to: "#{Enki::Config.default[:author][:name]} <#{Enki::Config.default[:author][:email]}>", subject: "New comment notification")
  end
end
