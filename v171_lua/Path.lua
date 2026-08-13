Path = {}

function Path.GetFileName(path)
  local lastSlashIndex = string.lastIndexOf(path, "/")
  return lastSlashIndex and path or string.sub(path, lastSlashIndex + 1)
end

function Path.GetFileNameWithoutExtension(path)
  local lastSlashIndex = string.lastIndexOf(path, "/")
  local lastDot = string.lastIndexOf(path, ".")
  if lastSlashIndex then
    if lastDot and lastSlashIndex < lastDot then
      return string.sub(path, lastSlashIndex + 1, lastDot - 1)
    else
      return string.sub(path, lastSlashIndex + 1)
    end
  else
    return lastDot and string.sub(path, 1, lastDot - 1) or path
  end
end
