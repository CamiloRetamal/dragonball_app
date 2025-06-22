require "httparty"

class CharactersController < ApplicationController
  before_action :authenticate_user!

  def index
    page = params[:page].to_i
    page = 1 if page <= 0

    limit = params[:limit].to_i
    limit = 10 if limit <= 0

    search = params[:search]

    url = "https://dragonball-api.com/api/characters"
    query = { page: page, limit: limit }
    query[:name] = search if search.present?

    response = HTTParty.get(url, query: query)

    if response.code == 200
      data = response.parsed_response

      if data.is_a?(Hash) && data["items"]
        @characters = data["items"]
        @total_characters = data.dig("meta", "totalItems") || @characters.size

        if search.present?
          @loaded_characters = @characters.size
        else
          total_hasta_ahora = limit * (page - 1) + @characters.size
          @loaded_characters = [ total_hasta_ahora, @total_characters ].min
        end
      elsif data.is_a?(Array)
        @characters = data
        @total_characters = @characters.size
        @loaded_characters = @characters.size
      else
        @characters = []
        @total_characters = 0
        @loaded_characters = 0
      end
    else
      @characters = []
      @total_characters = 0
      @loaded_characters = 0
    end

    @characters.each do |character|
      color_service = ColorImg.new(character["image"])
      color = color_service.color_fondo
      character["dominant_color"] = color
      character["fondo_oscuro"] = ColorImg.oscuro?(color)
    end

    @limit = limit
    @next_page = @characters.any? ? page + 1 : nil

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    character_id = params[:id]
    url = "https://dragonball-api.com/api/characters/#{character_id}"

    response = HTTParty.get(url)

    if response.code == 200
      @character = response.parsed_response
      color_service = ColorImg.new(@character["image"])
      @character["dominant_color"] = color_service.color_fondo
      @character["fondo_oscuro"] = ColorImg.oscuro?(@character["dominant_color"])
      @limit = params[:limit]
    else
      redirect_to characters_path(limit: params[:limit]), alert: "character no encontrado"
    end
  end
end
