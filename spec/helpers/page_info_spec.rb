# encoding: utf-8

require 'spec_helper'

module Gluttonberg
  module Blog
    describe Public do
      before :all do
        Gluttonberg::Setting.generate_common_settings
        @locale = Gluttonberg::Locale.generate_default_locale
        @user = User.new({
          :first_name => "First",
          :email => "valid_user@test.com",
          :password => "password1",
          :password_confirmation => "password1"
        })
        @user.role = "super_admin"
        @user.save
        @_blog = Weblog.create({
          :name => "The Futurist",
          :description => "Freerange Blog",
          :user => @user
        })
        @_article = create_article(@_blog)
        create_image_assets
      end

      after :all do
        clean_all_data
      end


      it "Blog title" do
        assign(:blog, @_blog)
        helper.page_title.should eql("The Futurist")
      end

      it "Article title" do
        assign(:article, @_article)
        helper.page_title.should eql("Article Title")
      end

      it "Blog keywords" do
        assign(:blog, @_blog)
        helper.page_keywords.should be_nil

        @_blog.seo_keywords = "blog, keywords"
        @_blog.save

        assign(:blog, @_blog)
        helper.page_keywords.should eql("blog, keywords")

        @_blog.seo_keywords = nil
        @_blog.save

        assign(:blog, @_blog)
        helper.page_keywords.should be_nil
      end

      it "Article keywords" do
        assign(:article, @_article)
        helper.page_keywords.should be_nil

        @_article.current_localization.seo_keywords = "article, keywords"
        @_article.save

        assign(:article, @_article)
        helper.page_keywords.should eql("article, keywords")

        @_article.current_localization.seo_keywords = nil
        @_article.save

        assign(:article, @_article)
        helper.page_keywords.should be_nil
      end


      it "Blog description" do
        assign(:blog, @_blog)
        helper.page_description.should eql("")

        @_blog.seo_description = "blog description"
        @_blog.save

        assign(:blog, @_blog)
        helper.page_description.should eql("blog description")

        @_blog.seo_description = nil
        @_blog.save

        assign(:blog, @_blog)
        helper.page_description.should eql("")
      end

      it "Article description" do
        assign(:article, @_article)
        helper.page_description.should eql("")

        @_article.current_localization.seo_description = "article description"
        @_article.save

        assign(:article, @_article)
        helper.page_description.should eql("article description")

        @_article.current_localization.seo_description = nil
        @_article.save

        assign(:article, @_article)
        helper.page_description.should eql("")
      end


      it "Blog fb_icon" do
        assign(:blog, @_blog)
        helper.page_fb_icon_path.should be_nil

        @_blog.fb_icon_id = @asset2.id
        @_blog.save

        assign(:blog, @_blog)
        helper.page_fb_icon_path.should eql("http://test.host" + @asset2.url)

        @_blog.fb_icon_id = nil
        @_blog.save

        assign(:blog, @_blog)
        helper.page_fb_icon_path.should be_nil
      end

      it "Article fb_icon" do
        assign(:article, @_article)
        helper.page_fb_icon_path.should be_nil

        @_article.current_localization.fb_icon_id = @asset2.id
        @_article.save

        assign(:article, @_article)
        helper.page_fb_icon_path.should eql("http://test.host" + @asset2.url)

        @_article.current_localization.fb_icon_id = nil
        @_article.save

        assign(:article, @_article)
        helper.page_fb_icon_path.should be_nil
      end

      it "Blog classes" do
        assign(:blog, @_blog)
        helper.body_class.should eql("weblog #{@_blog.slug}")
      end

      it "Article classes" do
        assign(:article, @_article)
        helper.body_class.should eql("post #{@_article.slug}")
      end

      private
        def create_article(blog)
          @article_params = {
            :name => "Article Title",
            :author => @user,
            :user => @user,
            :blog => blog
          }
          @article_loc_params = {
            :title => "Article Title",
            :excerpt => "intro",
            :body => "Introduction",
          }
          article = Article.new(@article_params)
          article.save
          article.create_localizations(@article_loc_params)
          article
        end

        def create_image_assets
          @file = GbFile.new(File.join(RSpec.configuration.fixture_path, "assets/gb_banner.jpg"))
          @file.original_filename = "gluttonberg_banner.jpg"
          @file.content_type = "image/jpeg"
          @file.size = 300

          @param = {
            :name=>"temp file",
            :file=> @file,
            :description=>"<p>test</p>"
          }

          Gluttonberg::Library.bootstrap

          @asset = Asset.new( @param )
          @asset.save.should == true

          @file2 = GbFile.new(File.join(RSpec.configuration.fixture_path, "assets/gb_logo.png"))
          @file2.original_filename = "gluttonberg_logo.png"
          @file2.content_type = "image/png"
          @file2.size = 300

          @param = {
            :name=>"temp file",
            :file=> @file2,
            :description=>"<p>test</p>"
          }

          Gluttonberg::Library.bootstrap

          @asset2 = Asset.new( @param )
          @asset2.save.should == true
        end


    end #member
  end
end