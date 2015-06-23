# Encoding: utf-8
require 'msgpack'
require 'redic'
require 'separa'
require 'filtra'

class Busca
  NAMESPACE   = 'Busca' #TODO: Confirm gem name
  LUA_CACHE   = Hash.new { |h, k| h[k] = Hash.new }
  LUA_INDEX   = File.expand_path("../lua/index.lua", __FILE__)
  LUA_SEARCH  = File.expand_path("../lua/search.lua", __FILE__)
  LUA_REMOVE  = File.expand_path("../lua/remove.lua", __FILE__)

  attr_reader :namespace, :redis, :separa, :filtra

  def initialize(opts = {})
    @namespace = opts[:namespace] || NAMESPACE
    @redis = opts[:redis] || Redic.new
    @separa = opts[:separa] || Separa.new
    @filtra = opts[:filtra] || Filtra.new
  end

  def split_and_filter(words)
    terms = @separa.call(words)
    filtered = @filtra.call(terms)
    return filtered
  end

  def index(document_id, string)
    words = split_and_filter(string)
    return [] if words.empty?
    index_id = script( LUA_INDEX, 0,
       @namespace.to_msgpack,
       document_id.to_msgpack,
       words.to_msgpack
      )
    return index_id
  end


  def search(string)
    words = split_and_filter(string)
    return [] if words.empty?
    document_ids = script( LUA_SEARCH, 0,
       @namespace.to_msgpack,
       words.to_msgpack
      )
    bitstring = document_ids.unpack('B*').join("")
    ids = []
    bitstring.each_char.each_with_index{|c, i| c == "1" ? ids.push(i) : nil}
    ids
    # document_ids
  end


  def remove(id)
    result = script( LUA_REMOVE, 0,
       @namespace.to_msgpack,
       id.to_msgpack
      )
    return result
  end

  private

  def script(file, *args)
    cache = LUA_CACHE[redis.url]

    if cache.key?(file)
      sha = cache[file]
    else
      src = File.read(file)
      sha = redis.call("SCRIPT", "LOAD", src)
      cache[file] = sha
    end
    redis.call("EVALSHA", sha, *args)
  end

end