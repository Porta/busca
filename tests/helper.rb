require "cutest"

require_relative "../lib/busca"

prepare do
    busca = Busca.new
    busca.redis.call("FLUSHDB")
end