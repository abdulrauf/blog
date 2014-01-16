# encoding: utf-8

module Gluttonberg
  module Admin
    module Blog
      class BlogsController < Gluttonberg::Admin::BaseController
        before_filter :find_blog, :only => [:show, :edit, :update, :delete, :destroy]
        before_filter :require_super_admin_user , :except => [:index]
        before_filter :authorize_user , :except => [:destroy , :delete]
        before_filter :authorize_user_for_destroy , :only => [:destroy , :delete]
        record_history :@blog

        def index
          @blogs = Gluttonberg::Blog::Weblog.paginate(:per_page => Gluttonberg::Setting.get_setting("number_of_per_page_items"), :page => params[:page])
          if @blogs && @blogs.size == 1
            redirect_to admin_blog_articles_path(@blogs.first)
          end
        end

        def show
          if @blog
            redirect_to admin_blog_articles_path(@blog)
          else
            redirect_to admin_blog_path
          end
        end

        def new
          @blog = Gluttonberg::Blog::Weblog.new
        end

        def create
          @blog = Gluttonberg::Blog::Weblog.new(params[:gluttonberg_blog_weblog])
          generic_create(@blog, {
            :name => "blog",
            :success_path => admin_blogs_path
          })
        end

        def edit
          unless params[:version].blank?
            @version = params[:version]
            @blog.revert_to(@version)
          end
        end

        def update
          @blog.assign_attributes(params[:gluttonberg_blog_weblog])
          generic_update(@blog, {
            :name => "blog",
            :success_path => admin_blogs_path
          })
        end

        def delete
          display_delete_confirmation(
            :title      => "Delete Blog '#{@blog.name}'?",
            :url        => admin_blog_path(@blog),
            :return_url => admin_blogs_path,
            :warning    => "This will delete all the articles that belong to this blog"
          )
        end

        def destroy
          generic_destroy(@blog, {
            :name => "blog",
            :success_path => admin_blogs_path,
            :failure_path => admin_blogs_path
          })
        end


        protected

          def find_blog
            @blog = Gluttonberg::Blog::Weblog.where(:id => params[:id]).first
          end

          def authorize_user
            authorize! :manage, Gluttonberg::Blog::Weblog
          end

          def authorize_user_for_destroy
            authorize! :destroy, Gluttonberg::Blog::Weblog
          end

      end
    end
  end
end
