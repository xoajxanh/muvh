StringPool = {}
local str2id = {}

function StringPool.ToID(str)
  local id = str2id[str]
  if not id then
    id = CS.Framework.StringPool.Add(str)
    str2id[str] = id
  end
  return id
end
