class PlayersController < ApplicationController
  skip_before_action :authenticate, only: [ :index ]

  require "uri"
  require "net/http"
  require 'resolv-replace'
  require 'cgi'
  require 'json'

  def index
    if params[:query].present?
      @pagy, @players = pagy(Player.search_by_uuid_or_username(params[:query]))
    else
      @pagy, @players = pagy(Player.order(created_at: :desc))
    end
  end

  def new
    @player = Player.new
  end

  def create
    my_hash = player_params.merge(wolfyApi(player_params[:uuid]))
    @player = Player.new(my_hash)
    @player.user = current_user
    @player_unique = Player.find_by(uuid: player_params[:uuid])
    if @player_unique.present?
      redirect_to root_path(query: player_params[:uuid]), alert: "Joueur déjà enregistré"
    else
      if wolfyApi(player_params[:uuid]).present?
        if @player.save
          Log.create(user: current_user, player: @player, action: "Enregistrement")
          redirect_to root_path(query: player_params[:uuid]), notice: "Joueur ajouté"
        else
          render "new", status: :unprocessable_entity
        end
      else
        redirect_to new_player_path, alert: "UUID invalide"
      end
    end
  end

  private

  def player_params
    params.require(:player).permit(:uuid)
  end

  def wolfyApi(uuid)
    url = URI("https://wolfy.net/api/leaderboard/player/#{CGI.escape(uuid)}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    request["Cookie"] = ENV["WOLFY_COOKIE"]
    response = https.request(request)
    if response.code == "200"
      parse = JSON.parse(response.read_body)
      {
        username: parse["user"]["username"]
      }
    else
      return nil
    end
  end
end
