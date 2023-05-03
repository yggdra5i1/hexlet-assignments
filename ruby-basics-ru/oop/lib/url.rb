# frozen_string_literal: true

require 'forwardable'
require 'uri'
require 'debug'

# BEGIN
class Url
  extend Forwardable
  # include Comparable
  attr_reader :base_url, :query_params
  def_delegators :@uri, :scheme, :host, :port

  def initialize(address)
    @base_url, @query_params = extract_components(address)
    @uri = URI(address)
  end

  def query_param(key, default = nil)
    query_params.fetch(key, default)
  end

  def ==(url)
    base_url == url.base_url && query_params && url.query_params
  end

  def !=(url)
    !self.==(url)
  end
  
  private

  def extract_components(address)
    base_url, params_str = address.split('?')
    [base_url, build_query_params(params_str)]
  end

  def build_query_params(params_str)
    return {} if params_str.nil?

    params = params_str.split('&')
    key_value_pairs = params.map do |param|
      k, v = param.split('=')
      [k.to_sym, v]
    end
    Hash[key_value_pairs]
  end
end
# END

