# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# Do not build partials
ignore '/partials/*'

# Uncomment to debug builds, bypassing all image copy
# ignore '/images/*'

# Build a page for each game
# data.index.each do |game_name|
#   proxy "/#{game_name}.html",
#         '/partials/game.html',
#         locals: { game_name: game_name },
#         ignore: true
# end

configure :development do
  activate :livereload
end
