require "httparty"

class PersonajesController < ApplicationController
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
        @personajes = data["items"]
        @total_personajes = data.dig("meta", "totalItems") || @personajes.size

        if search.present?
          @personajes_cargados = @personajes.size
        else
          total_hasta_ahora = limit * (page - 1) + @personajes.size
          @personajes_cargados = [ total_hasta_ahora, @total_personajes ].min
        end
      elsif data.is_a?(Array)
        @personajes = data
        @total_personajes = @personajes.size
        @personajes_cargados = @personajes.size
      else
        @personajes = []
        @total_personajes = 0
        @personajes_cargados = 0
      end
    else
      @personajes = []
      @total_personajes = 0
      @personajes_cargados = 0
    end

    @personajes.each do |personaje|
      color_service = ColorImg.new(personaje["image"])
      color = color_service.color_fondo
      personaje["dominant_color"] = color
      personaje["fondo_oscuro"] = ColorImg.oscuro?(color)
    end

    @limit = limit
    @next_page = @personajes.any? ? page + 1 : nil

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
      @personaje = response.parsed_response
      color_service = ColorImg.new(@personaje["image"])
      @personaje["dominant_color"] = color_service.color_fondo
      @personaje["fondo_oscuro"] = ColorImg.oscuro?(@personaje["dominant_color"])
      @limit = params[:limit]
    else
      redirect_to personajes_path(limit: params[:limit]), alert: "Personaje no encontrado"
    end
  end
end
