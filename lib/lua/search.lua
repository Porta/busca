local namespace = cmsgpack.unpack(ARGV[1])
local words     = cmsgpack.unpack(ARGV[2])


local function join(list, char)
  local temp_str = ""
  for k, v in pairs( list ) do
     temp_str = temp_str .. char .. v
  end
  temp_str = string.sub(temp_str, 2) --remove first '_'
  return temp_str
end

local function namespace_keys(list)
  local keys = {}
  for k, v in pairs( list ) do
    table.insert(keys, k, namespace .. ':' .. v)
  end
  return keys
end

local function temp_dest_key(words)
  local temp_key = join(words, '_')  
  local cached_key = namespace .. ':query_cache:' .. temp_key
  
  local cached = redis.call('GET', cached_key)
  
  return cached_key, cached
end

local function cache_results(temp_dest_key, results)
  -- no need to cache anything since the bitop operation
  -- already writes the result to cache
end


local function search(words)
  local cached_key, cached = temp_dest_key(words)
  if cached == false then
    redis.call('BITOP', 'AND', cached_key, unpack( namespace_keys(words) ) )
    cached = redis.call('GET', cached_key)
    if cached == false then
      cached = ""
    end
  end  
  return cached
end


local results = search(words)

return results
