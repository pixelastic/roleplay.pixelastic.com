# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# Do not build partials
ignore '/partials/*'
# Do not build the images sources
ignore '/img/sources/*'

# Shorter dir names in ./source
set :js_dir, 'js'
set :css_dir, 'css'
set :images_dir, 'img'

# Uncomment to debug builds, bypassing all image copy
# ignore '/images/*'

# Build a page for each session
data.index.each do |game|
  game.sessions.each do |session|
    proxy "/#{game.slug}/#{session.slug}.html",
          '/partials/session.html',
          locals: { game: game, session: session },
          ignore: true
  end
end

configure :development do
  activate :livereload
  # Auto-reload when a change in /data occurs
  set :reload_paths, [ "#{File.dirname __FILE__}/data" ]
end
