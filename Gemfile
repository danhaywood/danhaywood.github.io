# from https://github.com/johncarl81/transfuse-site/blob/master/Gemfile

source 'https://rubygems.org'

# only compatible with ruby 2.0 
# http://stackoverflow.com/questions/29123339/error-installed-wdm-gem-on-windows-system
gem 'wdm', '>= 0.1.0' if Gem.win_platform?

gem 'jekyll', '~> 2.5'
gem 'asciidoctor', '~> 1.5'
gem 'coderay', '1.1.0'

#instead of https://github.com/johncarl81/transfuse-site/commit/5fcd04c32ca140f2ef672104ca23986453a4d8c6#diff-8b7db4d5cc4b8f6dc8feb7030baa2478
#gem 'rake-jekyll', '~> 1.0'

group :jekyll_plugins do
  gem "jekyll-asciidoc"
end
