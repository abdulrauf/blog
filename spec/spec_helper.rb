# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

ENGINE_RAILS_ROOT = File.join( File.dirname(__FILE__), '../' )

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
Dir[File.join(ENGINE_RAILS_ROOT,"spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.fixture_path = "#{ENGINE_RAILS_ROOT}spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.order = "random"
end


def clean_all_data
  Gluttonberg::Locale.all.each{|locale| locale.destroy}
  Gluttonberg::Setting.all.each{|setting| setting.destroy}

  Gluttonberg::Asset.all.each{|asset| asset.destroy}
  Gluttonberg::Library.flush_asset_types
  Gluttonberg::AssetCategory.all.each{|asset_category| asset_category.destroy}
  Gluttonberg::AssetCollection.all.each{|collection| collection.destroy}

  User.all.each{|user| user.destroy}
  Gluttonberg::Member.all.each{|obj| obj.destroy}
  Gluttonberg::Blog::Weblog.all.each{|obj| obj.destroy}
  Gluttonberg::Blog::Article.all.each{|obj| obj.destroy}
  Gluttonberg::Blog::Comment.all.each{|obj| obj.destroy}
  Gluttonberg::Blog::CommentSubscription.all.each{|obj| obj.destroy}

  Gluttonberg::Feed.all.each{|obj| obj.destroy}
end


def create_image_asset
  file = Gluttonberg::GbFile.new(File.join(RSpec.configuration.fixture_path, "assets/gb_banner.jpg"))
  file.original_filename = "gluttonberg_banner.jpg"
  file.content_type = "image/jpeg"
  file.size = 300
  param = {
    :name=>"temp file",
    :file=> file,
    :description=>"<p>test</p>"
  }
  Gluttonberg::Library.bootstrap
  asset = Gluttonberg::Asset.new( param )
  asset.save
  asset
end