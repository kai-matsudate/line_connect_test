# frozen_string_literal: true
require 'faraday'
require 'json'
require 'securerandom'

class LinkAccountController < ApplicationController
  def index; end

  def generate_link_url
    url = fetch_link_url(params[:access_token])
    render json: {
      url: url
    }
  end

  private

  def fetch_link_url(access_token)
    conn = Faraday.new('https://api.line.me')
    # accessTokenのvalidation
    res = conn.get('/oauth2/v2.1/verify') do |req|
      req.params[:access_token] = access_token
    end

    json = JSON.parse(res.body)
    return unless res.success? || json['client_id'] == ENV['LINE_LOGIN_CLIENT_ID'] || json['expires_in'].to_i.positive?

    # user profileからline user idを取得
    res = conn.get('/v2/profile') do |req|
      req.headers['Authorization'] = "Bearer #{access_token}"
    end

    line_id = JSON.parse(res.body)['userId']

    # line user idを用いてアカウント連携用トークン（link token）を生成
    res = conn.post("/v2/bot/user/#{line_id}/linkToken") do |req|
      req.headers['Authorization'] = "Bearer #{ENV['MESSAGING_CHENNEL_TOKEN']}"
    end
    link_token = JSON.parse(res.body)['linkToken']

    nonce = SecureRandom.base64(20)

    # line platformでnonceとline idを関連づける
    "https://access.line.me/dialog/bot/accountLink?linkToken=#{link_token}&nonce=#{nonce}"
  end
end
