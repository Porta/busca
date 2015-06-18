local namespace = cmsgpack.unpack(ARGV[1])
local id        = cmsgpack.unpack(ARGV[2])


local function get_words(id)
  local words = redis.call('LRANGE', namespace .. ':document:' .. id .. ':words', 0, -1)
  return words
end

local function set_new_vacants(id)
  local id = redis.call('RPUSH', namespace .. ':vacants', id)
  return id
end

local function delete(id)
  -- add document id to vacants list
  set_new_vacants(id)  
  redis.call('DEL', namespace .. ':document:' .. id)

end

local function remove_from_index(words, id)
  for i, word in pairs(words) do
    redis.call('SETBIT', namespace .. ':' .. word, id, 0)
  end
end


local words = get_words(id)
delete(id)

remove_from_index(words, id)

return true