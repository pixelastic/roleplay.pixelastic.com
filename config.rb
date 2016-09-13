# Localized dates in french
I18n.default_locale = :fr

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
    proxy "#{game.slug}/#{session.name.slugify}.html",
          '/partials/session.html',
          locals: { game: game, session: session },
          ignore: true
  end
end

configure :development do
  activate :livereload
  # Auto-reload when a change in /data occurs
  set :reload_paths, ["#{File.dirname __FILE__}/data"]
end


helpers do
  def slug(input)
    input.slugify
  end

  # Gets the data associated with the game, from its name. It's basically only
  # reading in data.{game_name} but makes it easier to access
  def game(name)
    data.send(name.to_sym)
  end

  # Gets the root web path of a given session. Podcasts and images will be
  # relative to that path
  def session_path(game, session)
    File.join(
      game.slug,
      "#{session.date}-#{slug(session.name)}"
    )
  end

  # Gets the url of the image of this session
  def session_picture(game, session)
    picture = "/#{session_path(game, session)}/image.jpg"
    picture = cloudinary_thumbnail(picture) if build?
    picture
  end

  # Gets the filepath of the file containing the notes of the session
  def session_notes(game, session)
    filepath = File.expand_path(
      "./source/#{session_path(game, session)}/_notes.md"
    )
    return nil unless File.exist?(filepath)
    filepath
  end

  # Gets the filepath of the notes, relative to the partials directory, so we
  # can use it in partials
  def session_notes_filepath_for_partials(game, session)
    filepath = session_notes(game, session)
    split = filepath.split('/')
    source_index = split.find_index('source') + 1
    File.join('..', *split[source_index..-1])
  end

  # Check if session has a podcast
  def podcast?(game, session)
    filepath = File.expand_path(
      "./source/#{session_path(game, session)}/podcast.mp3"
    )
    File.exist?(filepath)
  end

  # Gets the filepath of podcast
  def session_podcast(game, session)
    "/#{session_path(game, session)}/podcast.mp3"
  end

  # Gets the first paragraph of notes of a session
  def session_description(game, session)
    note_file = session_notes(game, session)
    return nil if note_file.nil?

    raw = File.read(note_file)
    raw.split("\n\n").first
  end

  # Gets a human-readable version of the date of the session
  def session_date(session)
    I18n.localize(
      Date.strptime(session.date, '%Y-%m-%d'),
      format: '%-d %B %Y'
    )
  end

  def session_link(game, session)
    "/#{slug(game.name)}/#{slug(session.name)}.html"
  end

  def session_pictures(game, session)
    path = session_path(game, session)
    pictures = Dir.glob("./source/#{path}/*.jpg")

    # Removing the cover
    pictures = pictures.reject do |picture|
      File.basename(picture) == 'image.jpg'
    end

    # Using http urls
    pictures = pictures.map do |picture|
      "/#{path}/#{File.basename(picture)}"
    end

    pictures
  end

  def cloudinary(url, options)
    base_url = 'http://res.cloudinary.com/pixelastic-roleplay/image/fetch/'
    "#{base_url}#{options.join(',')}/http://roleplay.pixelastic.com#{url}"
  end

  def cloudinary_thumbnail(url)
    cloudinary(url, %w(w_400 q_100 c_scale f_auto))
  end

  def cloudinary_image(url)
    cloudinary(url, %w(q_90 f_auto))
  end
end
