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
        return if redirect_if_previous_path
        load_correct_version_and_localization

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
          redirect_to blog_article_path(:blog_id => @subscription.article.blog.slug, :id => @subscription.article.slug)
        else
          raise ActiveRecord::RecordNotFound.new
        end
      end

      private
        def find_blog
          @blog = Gluttonberg::Blog::Weblog.where(:slug => params[:blog_id]).includes([:articles]).first
          if @blog.blank?
            @blog = Gluttonberg::Blog::Weblog.published.where(:previous_slug => params[:blog_id]).first
          end
          @blog = nil if @blog && current_user.blank? && !@blog.published?
          raise ActiveRecord::RecordNotFound.new if @blog.blank?
        end

        def find_article
          @article = Gluttonberg::Blog::Article.where(:slug => params[:id], :blog_id => @blog.id).first
          find_article_by_previous_path
          @article = nil if @article && current_user.blank? && !@article.published?
          raise ActiveRecord::RecordNotFound.new if @article.blank?
        end

        def find_article_by_previous_path
          if @article.blank?
            @article = Gluttonberg::Blog::Article.published.where(:previous_slug => params[:id], :blog_id => @blog.id).first
          end
        end

        def redirect_if_previous_path
          if @blog.previous_slug == params[:blog_id] || @article.previous_slug == params[:id]
            redirect_to blog_article_path(:blog_id => @blog.slug , :id => params[:id]) , :status => 301
            true
          else
            false
          end
        end

        def load_correct_version_and_localization
          @article.load_localization(env['GLUTTONBERG.LOCALE'])
          if current_user && params[:preview].to_s == "true"
            Gluttonberg::AutoSave.load_version(@article.current_localization)
          end
        end

    end
  end
end
