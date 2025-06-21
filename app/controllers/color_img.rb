require "mini_magick"
require "open-uri"

class ColorImg
  def initialize(image_url)
    @image_url = image_url
  end

  def color_fondo
    Rails.cache.fetch(cache_key, expires_in: 30.days) do
      calcular_color
    end
  end

  private

  def calcular_color
    begin
      downloaded_image = download_image_tempfile(@image_url)
      image = MiniMagick::Image.open(downloaded_image.path)
      image.resize "1x1!"
      pixel_color = image.get_pixels[0][0]
      color = "rgb(#{pixel_color[0]}, #{pixel_color[1]}, #{pixel_color[2]})"
      downloaded_image.close
      downloaded_image.unlink
      color
    rescue => e
      Rails.logger.error "Error al extraer color de #{@image_url}: #{e.message}"
      "rgb(255, 255, 255)"
    end
  end

  def cache_key
    "dominant_color:#{Digest::SHA256.hexdigest(@image_url)}"
  end

  def download_image_tempfile(url)
    file = Tempfile.new([ "image", ".jpg" ])
    file.binmode
    file.write URI.open(url).read
    file.rewind
    file
  end

  def self.oscuro?(rgb_string)
    r, g, b = rgb_string.scan(/\d+/).map(&:to_i)
    luminancia = (0.299 * r + 0.587 * g + 0.114 * b)
    luminancia < 128
  end
end
