module MediaHelpers
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
