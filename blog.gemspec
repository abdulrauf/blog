$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gluttonberg/blog/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gluttonberg-blog"
  s.version     = Gluttonberg::Blog::VERSION
  s.authors     = ["Nick Crowther","Abdul Rauf", "Yuri Tomanek"]
  s.email       = ["office@freerangefuture.com"]
  s.homepage    = "http://gluttonberg.com"
  s.summary     = "Gluttonberg Blog is a peice of cake"
  s.description = "Gluttonberg Blog is a piece of cake"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  # s.add_dependency "gluttonberg-core", "~> 3"
  s.add_development_dependency 'rspec-rails', '2.14.1'
end
