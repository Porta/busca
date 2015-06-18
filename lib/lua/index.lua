local namespace = cmsgpack.unpack(ARGV[1])
local document_id  = cmsgpack.unpack(ARGV[2])
local words     = cmsgpack.unpack(ARGV[3])

local function check_for_vacants()
  local id = redis.call('RPOP', namespace .. ':vacants')
  return id
end

local function save(document_id, words)
  -- first try to get one available id from the vacants list
  local id = check_for_vacants()
  
  if id == false then
    id = redis.call('INCR', namespace .. ':document:ids')
  end

  redis.call('SET', namespace .. ':document:' .. id, document_id)

  return id
end


local function index(words, id)
  for i, word in pairs(words) do
    redis.call('SETBIT', namespace .. ':' .. word, id, 1)
    redis.call('RPUSH', namespace .. ':document:' .. id .. ':words', word)
  end
end


local id = save(document_id, words)

index(words, id)

return id
