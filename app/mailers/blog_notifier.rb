class BlogNotifier < Gluttonberg::BaseNotifier
  def comment_notification(subscriber , article , comment,current_localization_slug = "")
    setup_from
    @subscriber = subscriber
    @article = article
    @comment = comment
    @website_title = Gluttonberg::Setting.get_setting("title")
    @article_url = blog_article_url(current_localization_slug, article.blog.slug, article.slug)
    @unsubscribe_url = unsubscribe_article_comments_url(@subscriber.reference_hash)

    mail(:to => @subscriber.author_email, :subject => "Re: [#{@website_title}] #{@article.title}")
  end

  def comment_notification_for_admin(admin , article , comment)
    setup_email
    @admin = admin
    @article = article
    @blog = @article.blog
    @comment = comment
    @website_title = Gluttonberg::Setting.get_setting("title")
    @article_url = blog_article_url(:blog_id => article.blog.slug, :id => article.slug)

    mail(:to => @admin.email, :subject => "Re: [#{@website_title}] #{@article.title}")
  end

end