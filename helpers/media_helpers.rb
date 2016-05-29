module MediaHelpers
  def video?(media)
    File.extname(media) == '.mp4'
  end

  def image?(media)
    ['.jpg', '.png'].include?(File.extname(media))
  end

  def youtube_id(video, section)
    basename = File.basename(video, File.extname(video))
    section.youtube[basename]
  end

  def media_thumbnail(name, section)
    if image?(name)
      thumbnail = "/images/#{section.slug}/#{name}"
      thumbnail = cloudinary_thumbnail(thumbnail) if build?
      return thumbnail
    end

    id = youtube_id(name, section)
    "http://img.youtube.com/vi/#{id}/hqdefault.jpg"
  end

  def media_link(name, section)
    if image?(name)
      image = "/images/#{section.slug}/#{name}"
      image = cloudinary_image(image) if build?
      return image
    end

    id = youtube_id(name, section)
    "//www.youtube.com/watch?v=#{id}"
  end

  def cloudinary(url, options)
    base_url = 'http://res.cloudinary.com/pixelastic-videogames/image/fetch/'
    "#{base_url}#{options.join(',')}/http://videogames.pixelastic.com#{url}"
  end

  def cloudinary_thumbnail(url)
    cloudinary(url, %w(h_200 q_90 c_scale f_auto))
  end

  def cloudinary_image(url)
    cloudinary(url, %w(q_90 f_auto))
  end
end
