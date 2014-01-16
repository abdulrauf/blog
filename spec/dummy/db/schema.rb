# encoding: UTF-8

ActiveRecord::Schema.define(:version => 2014011610106) do
  create_table :gb_weblogs, :force => true do |t|
    t.string :name, :null => false
    t.string :slug, :null => false
    t.text :description
    t.integer :user_id, :null => false
    t.column :state , :string
    t.boolean :moderation_required, :default => true
    t.string :seo_title
    t.text :seo_keywords
    t.text :seo_description
    t.integer :fb_icon_id
    t.string :previous_slug
    t.datetime :published_at
    t.timestamps
  end

  create_table :gb_articles, :force => true do |t|
    t.string :slug, :null => false
    t.integer :blog_id, :null => false
    t.integer :user_id, :null => false
    t.integer :author_id, :null => false
    t.column :state , :string #use for publishing
    t.column :disable_comments , :boolean , :default => false
    t.datetime :published_at
    t.string :previous_slug
    t.integer :comments_count, :default => 0
    t.timestamps
  end

  create_table :gb_comments, :force => true do |t|
    t.text :body
    t.string :author_name
    t.string :author_email
    t.string :author_website
    t.references :commentable, :polymorphic => true
    t.integer :author_id
    t.boolean :moderation_required, :default => true
    t.boolean :approved, :default => false
    t.datetime :notification_sent_at
    t.boolean :spam , :default =>  false
    t.float   :spam_score
    t.timestamps
  end

  create_table :gb_comment_subscriptions, :force => true do |t|
    t.integer :article_id
    t.string :author_name
    t.string :author_email
    t.string :reference_hash
    t.timestamps
  end

  create_table :gb_article_localizations, :force => true do |t|
    t.string :title, :null => false
    t.text :excerpt
    t.text :body
    t.integer :featured_image_id
    t.column :article_id, :integer
    t.column :locale_id, :integer
    t.column :version, :integer
    t.string :seo_title
    t.text :seo_keywords
    t.text :seo_description
    t.integer :fb_icon_id
    t.timestamps
  end

  begin
    Gluttonberg::Blog::Weblog.create_versioned_table
  rescue => e
    puts e
  end

  begin
    Gluttonberg::Blog::Article # make sure article model is loaded.
    Gluttonberg::Blog::ArticleLocalization.create_versioned_table
  rescue => e
    puts e
  end

end