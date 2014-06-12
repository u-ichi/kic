# encoding: utf-8
#!/usr/bin/ruby
require 'rubygems'

require 'cgi'
require 'base64'
require 'digest/hmac'
require 'logger'
require 'net/http'
require 'time'
require 'unindent'
require 'rexml/document'
require 'nokogiri'
require 'happymapper'
require 'active_support'
require 'active_support/core_ext'

class Kic
  attr_reader :endpoint_url, :access_key, :secret_key
  attr_reader :logger, :response, :response_code

  def initialize(input_param = {})
    @logger        = input_param[:logger]        || Logger.new(STDOUT)

    @mapper        = input_param[:mapper]
    @auth_type     = input_param[:auth_type]     || :aws_signature_v2

    @endpoint_url  = input_param[:endpoint_fqdn]
    @endpoint_path = input_param[:endpoint_path] || '/'
    @endpoint_port = input_param[:endpoint_port] || 443
    @use_ssl       = input_param[:endpoint_ssl]  || true
    @access_key    = input_param[:access_key]
    @secret_key    = input_param[:secret_key]
  end

  def exec(query_param)
    signed_string = case @auth_type
                    when :aws_signature_v2
                      Kic::Auth::AwsSignatureV2.sign(self, query_param)
                    end

    get_msg = Net::HTTP::Get.new("#{@endpoint_path}?#{signed_string}")

    get_request(get_msg)

    unless response_code == 200
      logger.warn("response code is #{response_code}.")
    end

    @response
  end

  def mapper
    if @mapper
      "Kic::Mapper::#{@mapper.to_s.camelize}".constantize.new.parse(response)
    else
      nil
    end
  end

  private
  def use_ssl?
    @use_ssl
  end

  def get_request(msg)
    http = Net::HTTP.new("#{@endpoint_url}", @endpoint_port)

    if use_ssl?
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    response = http.start { |w| w.request(msg) }

    @response_code = response.code
    @response = response.body
  end
end

require 'kic/auth'
require 'kic/mapper'
require 'kic/mapper/cloudn_logging'
