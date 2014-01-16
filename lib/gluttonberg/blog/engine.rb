module Gluttonberg
  module Blog
    class Engine < ::Rails::Engine

      config.widget_factory_name = "Gluttonberg Blog"
      config.mount_at = '/'
      config.admin_path = '/admin'

      initializer "check config" do |app|
        config.mount_at += '/'  unless config.mount_at.last == '/'
      end

      initializer "init constants" do  |app|
      end

    end
  end
end