# Localized dates in french
I18n.default_locale = :fr

# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# Shorter dir names in ./source
set :js_dir, 'js'
set :css_dir, 'css'
set :images_dir, 'img'

# Haml throws error when handling Middleman-specific config, so we disable Haml
# validation altogether
# See https://github.com/middleman/middleman/issues/2113
Haml::TempleEngine.disable_option_validator!



configure :development do
  activate :livereload
  # Auto-reload when a change in /data occurs
  set :reload_paths, ["#{File.dirname __FILE__}/data"]
end

# Do not build partials
ignore '/partials/*'
# Do not build the images sources
ignore '/img/sources/*'
# Uncomment to debug builds, bypassing all image copy
# ignore '*.mp3'

class Roleplay
  # Return a slugified version
  def self.slug(input)
    input.slugify
  end

  # Directory path of the session, relative to ./source
  def self.source_session_path(game, session)
    File.join(
      game.slug,
      "#{session.date}-#{slug(session.name)}"
    )
  end

  # Filepath of the markdown file holding the session description, relative to
  # ./source
  def self.source_session_notes_path(game, session)
    File.join(
      source_session_path(game, session),
      '_notes.md'
    )
  end

  # Filepath of the mp3 podcast, relative to ./source
  def self.source_session_podcast_path(game, session)
    File.join(
      source_session_path(game, session),
      'podcast.mp3'
    )
  end

  # Filepath of the additional images of a session, relative to ./source
  def self.source_session_pictures_path(game, session)
    path = source_session_path(game, session)
    pictures = Dir.glob("./source/#{path}/*.{jpg,gif,png}").sort

    # Removing the cover
    pictures.reject! do |picture|
      File.basename(picture) == 'image.jpg'
    end

    # Removing the ./source prefix
    pictures.map! do |picture|
      picture.gsub('/source/', '/')
    end

    pictures
  end

  # Web path of the session, relative to /
  def self.build_session_path(game, session)
    File.join('/', game.slug, slug(session.name), '/')
  end

  # Web path of the picture illustrating a session
  def self.build_session_picture_path(game, session)
    File.join(
      build_session_path(game, session),
      'image.jpg'
    )
  end

  # Web path of all the additional pictures of a session
  def self.build_session_pictures_path(game, session)
    pictures = source_session_pictures_path(game, session)
    date = session.date
    pictures.map! do |picture|
      picture.gsub("/#{date}-", '/')[1..-1]
    end
  end

  # Web path of the mp3 podcast of a session
  def self.build_session_podcast_path(game, session)
    File.join(
      build_session_path(game, session),
      'podcast.mp3'
    )
  end
end

# Build a page for each session
data.index.each do |game|
  # Index page, listing all sessions of a given name
  proxy "#{game.slug}/index.html",
        '/partials/game.html',
        locals: { game: game },
        ignore: true

  # For each session of the game
  previous_session = nil
  next_session = nil
  game.sessions.each_with_index do |session, index|
    next_session = game.sessions[index + 1]
    # Creating the detail of the session
    proxy "#{game.slug}/#{Roleplay.slug(session.name)}/index.html",
          '/partials/session.html',
          locals: {
            game: game,
            session: session,
            next_session: next_session,
            previous_session: previous_session
          },
          ignore: true

    previous_session = session
  end
end


# Change the resource list so the final build does not include dates in
# directories
unless defined?(Middleman::Extension::RemoveDateFromDirectories) == 'constant'
  class RemoveDateFromDirectories < Middleman::Extension
    def initialize(app, options_hash={}, &block)
      super
    end
    def manipulate_resource_list(resources)
      resources.each do |resource|
        next if resource.ignored?

        # Skipping simple files
        destination_path = resource.destination_path
        path_split = destination_path.split('/')
        next if path_split.size != 3

        # Skipping assets
        game = path_split[0]
        next if ['fonts', 'img', 'css', 'js'].include?(game)

        # Reconstruction the final path by removing the date
        dirname = path_split[1]
        basename = path_split[2]
        session = dirname[11..-1]
        final_path = "#{game}/#{session}/#{basename}"
        resource.destination_path = final_path
      end

      resources
    end
  end
  ::Middleman::Extensions.register(:remove_date_from_directories, RemoveDateFromDirectories)
  activate :remove_date_from_directories
end

helpers do
  def nav_active(slug)
    current_page.path =~ /^#{slug}\// ? 'b bg-green' : ''
  end

  def session_url(game, session)
    Roleplay.build_session_path(game, session)
  end

  def session_picture_url(game, session)
    Roleplay.build_session_picture_path(game, session)
  end

  def session_podcast_url(game, session)
    Roleplay.build_session_podcast_path(game, session)
  end

  def session_date(session)
    I18n.localize(
      Date.strptime(session.date, '%Y-%m-%d'),
      format: '%-d %B %Y'
    )
  end

  def session_description_short(game, session)
    notes_file = File.join(
      './source',
      Roleplay.source_session_notes_path(game, session)
    )
    return nil unless File.exists?(notes_file)

    raw = File.read(notes_file)
    raw.split("\n\n").first
  end

  def session_pictures(game, session)
    Roleplay.build_session_pictures_path(game, session)
  end

  def session_podcast(game, session)
    Roleplay.build_session_podcast_path(game, session)
  end

  def podcast?(game, session)
    File.exist?(File.join(
      './source',
      Roleplay.source_session_podcast_path(game, session))
    )
  end

  def render_description(game, session)
    note_path = Roleplay.source_session_notes_path(game, session)
    path_relative_to_partials = File.join('..', note_path)

    html = partial(path_relative_to_partials)

    # Images used in markdown are relative to the :images_dir. When in a game
    # session, we want them relative to the current directory, so we remove the
    # :images_dir prefix
    html.gsub(%r{src="/img/}, 'src="')
  end

  def cloudinary(url, options)
    return url unless build?
    base_url = 'https://res.cloudinary.com/pixelastic-roleplay/image/fetch/'
    "#{base_url}#{options.join(',')}/https://roleplay.pixelastic.com#{url}"
  end
end
