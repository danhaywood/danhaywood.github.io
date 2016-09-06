
cat >/tmp/$$.rb <<EOF
require 'launchy'

Launchy.open("http://localhost:4000")
EOF
ruby /tmp/$$.rb

bundle exec jekyll serve

