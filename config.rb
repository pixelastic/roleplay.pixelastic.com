# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# Do not build partials
ignore '/partials/*'

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
end
