module Gluttonberg
  module Public
    class ArticlesController <   Gluttonberg::Public::BaseController
      before_filter :find_blog, :only => [:index, :show, :preview]

      def index
        @articles = @blog.articles.published.includes(:localizations)
        respond_to do |format|
          format.html
          format.rss { render :layout => false }
        end
      end

      def show
        find_article
        if @blog.previous_slug == params[:blog_id] || @article.previous_slug == params[:id]
          redirect_to blog_article_path(:blog_id => @blog.slug , :id => params[:id]) , :status => 301
          return
        end
        @article.load_localization(env['GLUTTONBERG.LOCALE'])
        if current_user && params[:preview].to_s == "true"
          Gluttonberg::AutoSave.load_version(@article.current_localization)
        end

        @comments = @article.comments.where(:approved => true)
        @comment = Gluttonberg::Blog::Comment.new(:subscribe_to_comments => true)
        respond_to do |format|
          format.html
        end
      end

      def tag
        @articles = Gluttonberg::Blog::Article.tagged_with(params[:tag]).includes(:blog).published
        @tags = Gluttonberg::Blog::Article.published.tag_counts_on(:tag)
        respond_to do |format|
          format.html
        end
      end

      def unsubscribe
        @subscription = Gluttonberg::Blog::CommentSubscription.where(:reference_hash => params[:reference]).first
        unless @subscription.blank?
          @subscription.destroy
          flash[:notice] = "You are successfully unsubscribe from comments of \"#{@subscription.article.title}\""
          redirect_to blog_article_path(@subscription.article.blog.slug, @subscription.article.slug)
        end
        respond_to do |format|
          format.html
        end
      end

      private
        def find_blog
          @blog = Gluttonberg::Blog::Weblog.where(:slug => params[:blog_id]).includes([:articles]).first
          @blog = nil if @blog && current_user.blank? && !@blog.published?
          if @blog.blank?
            @blog = Gluttonberg::Blog::Weblog.published.where(:previous_slug => params[:blog_id]).first
          end
          raise ActiveRecord::RecordNotFound.new if @blog.blank?
        end

        def find_article
          @article = Gluttonberg::Blog::Article.where(:slug => params[:id], :blog_id => @blog.id).first
          @article = nil if @article && current_user.blank? && !@article.published?
          if @article.blank?
            @article = Gluttonberg::Blog::Article.published.where(:previous_slug => params[:id], :blog_id => @blog.id).first
          end
          raise ActiveRecord::RecordNotFound.new if @article.blank?
        end

    end
  end
end
