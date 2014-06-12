class Kic::Auth::AwsSignatureV2 < Kic::Auth ; class << self
  def sign(kic, input_query_param)
    default_param = {
      AWSAccessKeyId:   kic.access_key,
      SignatureMethod: 'HmacSHA256',
      SignatureVersion: 2,
      Version:          '2012-04-23',
      Timestamp:        Time.now.iso8601
    }

    signed_query_param = input_query_param.merge!(default_param)

    canonical_querystring = input_query_param.sort.collect { |key, value| [CGI.escape(key.to_s), CGI.escape(value.to_s)].join('=') }.join('&')

    unsigned_string = "GET\n#{kic.endpoint_url}\n/\n#{canonical_querystring}"

    hmac = Digest::HMAC.new(kic.secret_key, Digest::SHA256)
    hmac.update(unsigned_string)
    signed_query_param[:Signature] = Base64.encode64(hmac.digest).chomp

    signed_query_param.collect { |key, value| [CGI.escape(key.to_s), CGI.escape(value.to_s)].join('=') }.join('&')
  end
end
end
