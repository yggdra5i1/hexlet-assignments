# frozen_string_literal: true

require 'uri'
require 'forwardable'

# BEGIN
class Url
  include Comparable
  extend Forwardable

  def_delegators :@uri, :scheme, :host, :port

  def initialize(url)
    @uri = URI(url)
    @params = extract_params(@uri)
  end

  def query_params
    @params
  end

  def query_param(key, default = nil)
    @params.fetch(key, default)
  end

  def <=>(other)
    [scheme, host, port, query_params] <=> [other.scheme, other.host, other.port, other.query_params]
  end

  private

  def extract_params(uri)
    query = uri.query || ''
    query_parts = query.split('&')
    query_parts.each_with_object({}) do |qp, acc|
      key, value = qp.split('=')
      acc[key.to_sym] = value
    end
  end
end
# END

