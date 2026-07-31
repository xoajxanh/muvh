array = {}

function array.length(t)
  return t and #t or 0
end

function array.clear(t)
  local count = #t
  for i = 1, count do
    table.remove(t)
  end
end

function array.contains(t, item)
  return array.indexOf(t, item) ~= nil
end

function array.indexOf(t, item)
  for k, v in ipairs(t) do
    if v == item then
      return k
    end
  end
  return nil
end

function array.random(t)
  math.randomseed(os.time())
  for i = 1, #t do
    local j = math.random(i)
    table[i], table[j] = table[j], table[i]
  end
end
