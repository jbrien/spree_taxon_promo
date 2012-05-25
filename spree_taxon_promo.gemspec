# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_taxon_promo'
  s.version     = '1.1.0'
  s.summary     = 'A promotion that can be applied to products in a specific taxon'
  s.description = ''
  s.required_ruby_version = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.6"

  s.author    = 'Greg Reinacker'
  s.email     = 'gregr@rassoc.com'
  s.homepage  = 'http://www.rassoc.com'

  s.files        = Dir['LICENSE', 'README.md', 'app/**/*', 'config/**/*', 'lib/**/*', 'db/**/*', 'vendor/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 1.1.0'
  s.add_dependency 'spree_promo', '~> 1.1.0'
end
