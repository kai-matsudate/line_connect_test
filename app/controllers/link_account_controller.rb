# frozen_string_literal: true
require 'faraday'
require 'json'
require 'securerandom'

class LinkAccountController < ApplicationController
  def index
    # accessTokenのvalidation
    response = Faraday.get('https://api.line.me/oauth2/v2.1/verify', access_token: params[:access_token])
    return unless response.success?

    json = JSON.parse(response.body)
    return unless json['client_id'] == ENV['LINE_LOGIN_CLIENT_ID'] || json['expires_in'].to_i > 0

    # user profileからline user idを取得
    response = Faraday.get('https://api.line.me/v2/profile',nil,
                           {
                             Authorization: 'Bearer ' + params[:access_token]
                           }
    )
    line_id = JSON.parse(response.body)['userId']

    # line user idを用いてアカウント連携用トークン（link token）を生成
    response = Faraday.post("https://api.line.me/v2/bot/user/#{line_id}/linkToken", nil,
                            {
                              Authorization: 'Bearer ' + params[:access_token]
                            })
    link_token = JSON.parse(response.body)['linkToken']

    nonce = SecureRandom.base64(20)

    # line platformでnonceとline idを関連づける
    redirect_to "https://access.line.me/dialog/bot/accountLink?linkToken=#{link_token}&nonce=#{nonce}"
  end
end
