require "gluttonberg/blog/engine"

module Gluttonberg
  module Blog
    def self.installed?
      Gluttonberg::Blog::Weblog.table_exists?
    end
  end
end