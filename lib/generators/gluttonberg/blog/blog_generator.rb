require 'rails/generators'
require 'rails/generators/migration'    

class Gluttonberg::BlogGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  
  def self.source_root
    @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end
  
  def self.next_migration_number(dirname)
    Gluttonberg.next_migration_number(dirname)
  end

  def create_migration_file
    migration_template 'blog_migration.rb', 'db/migrate/blog_migration.rb'
  end
  
  def generate_views
    build_views
  end
    
  protected

    def build_views
      views = {
        'blogs_index.html.haml' => File.join('app/views/gluttonberg/public/blog/blogs', "index.html.haml"),
        'blogs_show.html.haml' => File.join('app/views/gluttonberg/public/blog/blogs', "show.html.haml"),
        'articles_index.html.haml' => File.join('app/views/gluttonberg/public/blog/articles', "index.html.haml"),
        'articles_show.html.haml' => File.join('app/views/gluttonberg/public/blog/articles', "show.html.haml"),
        'articles_tag.html.haml' => File.join('app/views/gluttonberg/public/blog/articles', "tag.html.haml")
      }
      copy_views(views)
    end

    def copy_views(views)
      views.each do |template_name, output_path|
        template template_name, output_path
      end
    end
    
end